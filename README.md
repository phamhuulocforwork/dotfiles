## 🚀 Các bước cài đặt WSL, Zsh và Oh My Zsh

### Bước 1: Cài đặt WSL (Windows Subsystem for Linux)

#### 1.1 Kích hoạt WSL feature

Mở **PowerShell** với quyền Administrator và chạy:

```powershell
# Kích hoạt WSL feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Kích hoạt Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

#### 1.2 Cài đặt WSL 2

```powershell
# Cài đặt WSL và Ubuntu (distribution mặc định)
wsl --install

# Hoặc cài đặt distribution cụ thể
wsl --install -d Ubuntu
```

#### 1.3 Thiết lập WSL 2 làm phiên bản mặc định

```powershell
wsl --set-default-version 2
```

#### 1.4 Khởi động lại máy tính

Sau khi cài đặt xong, **khởi động lại máy tính**.

### Bước 2: Thiết lập Ubuntu trong WSL

#### 2.1 Mở Ubuntu

- Tìm "Ubuntu" trong Start Menu và mở
- Hoặc mở Terminal/PowerShell và chạy: `wsl`

#### 2.2 Tạo user và password

Khi lần đầu mở Ubuntu, bạn sẽ được yêu cầu:

- Tạo username
- Tạo password

#### 2.3 Cập nhật hệ thống

```bash
# Cập nhật package list
sudo apt update

# Nâng cấp các package
sudo apt upgrade -y
```

### Bước 3: Cài đặt Zsh

#### 3.1 Cài đặt Zsh

```bash
# Cài đặt zsh
sudo apt install zsh -y

# Kiểm tra version
zsh --version
```

#### 3.2 Cài đặt Oh My Zsh

```bash
# Cài đặt Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Bước 4: Sử dụng dotfiles

#### 4.1 Clone dotfiles

```bash
# Di chuyển về home directory
cd ~

# Clone dotfiles repository
git clone https://github.com/phamhuulocforwork/dotfiles.git

# Di chuyển vào thư mục dotfiles
cd dotfiles
```

#### 4.2 Chạy script cài đặt

```bash
# Chạy script cấu hình
chmod +x config.sh
./config.sh

# Chạy script setup zsh (script này sẽ cài đặt theme và plugins)
chmod +x setup-zsh.sh
./setup-zsh.sh
```
