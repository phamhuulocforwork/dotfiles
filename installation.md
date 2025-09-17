# Arch Linux Installation Guide - Minimal Profile

This guide walks you through installing Arch Linux using the `archinstall` script with a minimal desktop profile.

## Prerequisites

- A computer with UEFI firmware
- At least 2GB RAM and 20GB storage
- Stable internet connection
- USB drive (4GB minimum)

## Step 1: Create Bootable USB

### Download Required Files

1. Download the latest Arch Linux ISO from the [official website](https://archlinux.org/download/)
2. Download [refus](https://rufus.ie/)

### Create Bootable USB

1. Insert your USB drive into your computer.
2. Open Rufus.
3. In Rufus, select your USB drive under "Device".
4. Under "Boot selection", click "SELECT" and choose the downloaded Arch Linux ISO file.
5. Leave the default options (Partition scheme: GPT, File system: FAT32) unless you have specific requirements.
6. Click "START" and confirm any prompts to begin writing the ISO to the USB drive.
7. Wait for Rufus to finish creating the bootable USB.

## Step 2: Boot from USB

1. Insert the USB drive and restart your computer.
2. Press the boot menu key (usually F12, F2, or Del) during startup.
3. Select your USB drive from the boot menu.
4. The Arch Linux boot menu will appear—select "Boot Arch Linux (x86_64)" or the default option to start the installer.

## Step 3: Connect to Internet

### Wired Connection

Wired connections work automatically - no configuration needed.

### Wireless Connection

Use the `iwctl` utility for WiFi setup:

```sh [sh]
iwctl
```

From the `[iwd]#` prompt, list available devices and connect:

```sh [sh]
[iwd]# device list
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "Your-WiFi-Name"
```

Enter your WiFi password when prompted, then exit with `Ctrl+D` or

```sh [sh]
exit
```

### Verify Connection

```sh [sh]
ping -c 3 archlinux.org
```

## Step 4: Prepare Disk Partitions

### View Available Disks

```sh [sh]
lsblk
```

### Create Partitions

Use `cfdisk` to create partitions:

```sh [sh]
cfdisk /dev/nvme0nX  # Replace X with your disk letter
```

Create these three partitions:

| Partition        | Size      | Type             | Purpose        |
| ---------------- | --------- | ---------------- | -------------- |
| `/dev/nvme0n1p1` | 512MB     | EFI System       | Boot partition |
| `/dev/nvme0n1p2` | Remaining | Linux filesystem | Root partition |

### Format Partitions

Replace `/dev/nvme0n1p#` with your actual partition paths:

```sh [sh]
# Format root partition
mkfs.ext4 /dev/nvme0n1p2

# Format EFI partition
mkfs.vfat -F32 /dev/nvme0n1p1
```

### Mount Partitions

```sh [sh]
mount /dev/nvme0n1p1 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
```

## Step 5: Update System and Launch Installer

```sh [sh]
# Update package database and install latest archinstall
pacman -Sy archinstall archlinux-keyring

# Launch the installer
archinstall
```

## Step 6: Configure Installation

The `archinstall` script will present a menu. Configure each option:

### Required Settings

1. **Locales**

   - Keyboard layout: Select your keyboard layout
   - Locale language: Choose your language (e.g., en_US)
   - Locale encoding: UTF-8 (default)

2. **Mirrors**

   - Select mirror region closest to your location

3. **Disk configuration**

   - Choose "Partitioning"
   - Select "Pre-mounted configuration"
   - Enter mount point: `/mnt`

4. **Swap**

   - Enable if you created a swap partition

5. **Bootloader**

   - Recommended: `grub` for broader compatibility
   - Alternative: `systemd-bootctl` for UEFI systems

6. **Hostname**

   - Enter a name for your computer (e.g., `arch`)

7. **Root password**

   - Set a strong password for the root account

8. **User account**
   - Create a regular user account
   - Add to user account to sudo group access

### Profile and Software

9. **Profile**

   - Select "Type" → "Minimal"
   - This installs a base system without desktop environment

10. **Audio**

    - Select "Pipewire" (modern audio system)

11. **Kernels**

    - Keep default "linux" kernel
    - Add "linux-lts" for stability if desired

12. **Network configuration**

    - Select "Use NetworkManager"

13. **Additional packages**

    - Add essential packages: `git nano`

14. **Optional repositories**
    - Enable `multilib` for 32-bit application support

### Final Settings

15. **Timezone**

    - Select your timezone

16. **Automatic time sync (NTP)**
    - Leave enabled (recommended)

## Step 7: Install System

1. Review all settings carefully
2. Select "Install" to begin the installation
3. Confirm when prompted
4. Wait for installation to complete (10-30 minutes)

## Step 7.5: Manual GRUB Setup (if archinstall did not configure bootloader)

> **Note:** After completing Step 7 and installing the system, if you are unable to boot into your new Arch Linux installation, you may need to manually set up the GRUB bootloader.
>
> To do this, reboot your computer, boot back into the Arch Linux installation USB, and then chroot into your newly installed system. Once you are in the chroot environment as root, follow the steps below to configure GRUB manually:

1. **Install GRUB and EFI tools:**

   ```sh
   pacman -S grub efibootmgr dosfstools mtools
   ```

2. **Install GRUB for UEFI systems:**

   ```sh
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
   ```

3. **(Optional) Install some useful applications:**

   ```sh
   pacman -S firefox curl flatpak
   ```

4. **Exit chroot and unmount partitions:**

   ```sh
   exit
   umount -lR /mnt
   shutdown now
   ```

5. **After rebooting into your new system:**

   - Edit GRUB configuration if needed:

     ```sh
     sudo nano /etc/default/grub
     ```

   - Connect to Wi-Fi (replace `[wifi_name]` and `"[password]"`):

     ```sh
     sudo nmcli dev wifi connect [wifi_name] password "[password]"
     ```

   - Install `os-prober` to detect other OSes:

     ```sh
     sudo pacman -S os-prober
     ```

   - Regenerate the GRUB configuration:
     ```sh
     sudo grub-mkconfig -o /boot/grub/grub.cfg
     ```

> After these steps, your system should be able to boot properly using GRUB.

## Step 8: Post-Installation

1. When installation completes, remove the USB drive
2. Reboot the system:

   ```sh [sh]
   reboot
   ```

3. Log in with your user account
4. Update the system:
   ```sh [sh]
   sudo pacman -Syu
   ```

## Next Steps

Your minimal Arch Linux system is now ready!

**Congratulations!** 🎉 You've successfully installed Arch Linux and can now proudly say "I use Arch, btw!"
