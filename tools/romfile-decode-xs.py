#!/usr/bin/env python3
import gzip
import os
import argparse
import subprocess
import tempfile
import struct

def find_and_decrypt(input_path, output_path, key_path):
    """
    Tự động dò tìm, cắt gọn và giải mã file cấu hình firmware.
    """
    try:
        # 1. Đọc và kiểm tra giải nén Gzip
        with open(input_path, 'rb') as f:
            data = f.read()
        
        if data.startswith(b'\x1f\x8b'):
            content = gzip.decompress(data)
        else:
            content = data

        # 2. Dò tìm Header PKCS7 (Magic Number: 30 82)
        start_idx = content.find(b'\x30\x82')
        if start_idx == -1:
            print(f"[-] Error: Could not find PKCS7 header in {input_path}")
            return False

        # 3. Tính toán độ dài chuẩn từ ASN.1 Header
        payload = content[start_idx:]
        content_len = struct.unpack(">H", payload[2:4])[0]
        actual_size = content_len + 4
        final_payload = payload[:actual_size]

        # 4. Giải mã bằng OpenSSL thông qua file tạm
        with tempfile.NamedTemporaryFile(suffix=".der", delete=False) as tmp:
            tmp.write(final_payload)
            tmp_path = tmp.name

        cmd = [
            "openssl", "smime", "-decrypt",
            "-inform", "DER",
            "-in", tmp_path,
            "-out", output_path,
            "-inkey", key_path
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if os.path.exists(tmp_path):
            os.remove(tmp_path)

        if result.returncode == 0:
            print(f"[+] Success: {os.path.basename(input_path)} -> {output_path}")
            return True
        else:
            print(f"[-] OpenSSL Error: {result.stderr.strip()}")
            return False

    except Exception as e:
        print(f"[-] System Error: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description="Professional Firmware Config Decrypter")
    parser.add_argument("-i", "--input", required=True, help="Path to encrypted .gz or binary file")
    parser.add_argument("-o", "--output", required=True, help="Path to save decrypted .cfg file")
    parser.add_argument("-k", "--key", required=True, help="Path to private .pem key")

    args = parser.parse_args()
    
    find_and_decrypt(args.input, args.output, args.key)

if __name__ == "__main__":
    main()
