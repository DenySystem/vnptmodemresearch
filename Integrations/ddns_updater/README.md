<h1 align="center">DDNS Updater</h1>
<h4 align="center">tốt hơn cái mặc định nhiều, không tốt không lấy tiền!</h4>
<h6 align="left">BussyBakks, D:25/M:10/Y:2025</h6>

> [!NOTE]
> Sự ổn định của app này cho router vẫn còn đang được xem xét  
> Vì lý do flash không đủ chỗ trống (cao nhất chỉ 12-15MB) nên chỉ được sử dụng 1 trong những app đã được test (AdGuard, DDNS Updater, ...)

## 1: <ins>Yêu cầu</ins>
* Mở được telnet/ssh trên router đã đề cập ở [ngoài kia](https://github.com/DenySystem/vnptmodemresearch?tab=readme-ov-file#3-shell-v%C3%A0-nh%E1%BB%AFng-ng%C6%B0%E1%BB%9Di-b%E1%BA%A1n-tty-ssh-)  

> [!CAUTION]
> **[!!! WORK IN PROGRESS !!!]**  
> **Bạn sẽ tự chịu hết các hậu quả đi kèm nếu làm theo!!!**  
> **Và chúng mình KHÔNG CHỊU TRÁCH NHIỆM nếu bị lỗi trên router nhà bạn**  
> *đã nhắc rồi nhé.*

> [!WARNING]
> Hiện tại chỉ có dòng [GW040-NS](https://www.vnpt-technology.vn/vi/product_detail/gpon-ont-igate-gw040-ns) đã confirm chạy okay  
---
## 2: <ins>Cài đặt</ins>
### 2.1: Vấn đề config
* Router của VNPT xem FTP uploads như là firmware updates nên không thể upload trực tiếp  
* Nên muốn edit config ddns_updater thì bắt buộc (i guess) dùng netcat (nc)  
* Nếu bản BusyBox của router không có netcat, hãy tải bản BusyBox có netcat bằng lệnh sau  
```sh
cd /tmp/userdata
mkdir busy
/userfs/bin/curl -k -o busy/busybox https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv5l
chmod 777 /tmp/userdata/busy/busybox
```
* (Sau bước này, tất cả các lệnh **"nc"** đều thay cho **"/tmp/userdata/busy/busybox nc"** trên router)

### 2.2: Bước đầu cài đặt
* Paste đống lệnh này vào shell

> [!CAUTION]
> **LƯU Ý KHI CHẠY LẠI SCRIPT**  
> **TẤT CẢ CÁC FILE NẰM TRONG FOLDER `/tmp/userdata/ddns_updater` SẼ BỊ XOÁ**  
> **LƯU Ý TRƯỚC KHI CHẠY, KHÔNG LÀ MẤT HẾT CONFIG THÌ PHẢI TỰ CHỊU**  

```sh
cd /tmp && /userfs/bin/curl -k -o install-ddns.sh https://raw.githubusercontent.com/DenySystem/vnptmodemresearch/refs/heads/master/Integrations/ddns_updater/install.sh && chmod +x install-ddns.sh && sh install-ddns.sh
```
* Nó sẽ lên như thế này  
<img width="931" height="896" alt="Screenshot 2025-10-25 193709" src="https://github.com/user-attachments/assets/fc122be1-fd80-4f45-af3a-c1d5bcae0dcb" />

* Check app đã chạy hay chưa bằng cách access vào `http://(gateway ip):8000`, nếu lên UI được thì ok, không thì xem lại có bị block iptables hay không  
* Ctrl + C để thoát vì cần phải config nữa.

### 2.2: Configurations
* Như đã nói ở trên, FTP không thể dùng để edit file nên phải dùng netcat
* Sau khi có netcat, gõ lệnh sau (Lưu ý **nc** là viết tắt của **/tmp/userdata/busy/busybox nc** trên router
```sh
cd /tmp/userdata/ddns_updater
nc -l -p 32000 > data/config.json < /dev/null
```
* Trên máy bạn: 
	* Tạo file `config.json`, config theo [docs](https://github.com/qdm12/ddns-updater/tree/master/docs) của app và lưu lại
	* Nếu sài Linux thì netcat đã được cài đặt sẳn, send file bằng cách nhập lệnh sau vào máy Linux
```sh
cat config.json | netcat (gateway ip) 32000
```
* Còn Windows, tải netcat tại [đây](https://github.com/int0x33/nc.exe/blob/master/nc64.exe) và chạy lệnh sau
```batch
type config.json | nc64 (gateway ip) 32000
```
* Sau đó Ctrl + C bên máy Linux hoặc Windows là xong send config
* Chạy lại DDNS Updater (**/tmp/userdata/ddns_updater/updater_v5**) và xong!
* Check lại `http://(gateway ip):8000` và xem domain của bạn đã hiện lên hay chưa

## Ngoài lề
* Cũng như AdGuard, nếu có vấn đề cần trợ giúp, hãy tạo issue đề ở đầu **`[DDNS]`** để được trợ giúp
