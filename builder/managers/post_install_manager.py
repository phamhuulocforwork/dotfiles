import os
import subprocess
import traceback

from loguru import logger

class PostInstallation:
    @staticmethod
    def apply():
        logger.info("The post-installation configuration is starting...")
        PostInstallation._install_fastfetch()
        PostInstallation._setup_fish_shell()
        PostInstallation._install_docker()
        PostInstallation._install_nvm_nodejs()
        PostInstallation._install_homebrew()
        PostInstallation._install_uv()
        PostInstallation._install_oh_my_posh()
        PostInstallation._configure_fastfetch()
        logger.info("The post-installation configuration is complete!")

    @staticmethod
    def _install_fastfetch() -> None:
        logger.info("Installing Fastfetch...")

        try:
            # Download and install fastfetch binary
            fastfetch_url = "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz"
            subprocess.run(["curl", "-L", "-o", "/tmp/fastfetch.tar.gz", fastfetch_url], check=True)

            # Extract and install
            subprocess.run(["tar", "-xzf", "/tmp/fastfetch.tar.gz", "-C", "/tmp"], check=True)
            subprocess.run(["sudo", "cp", "/tmp/fastfetch-linux-amd64/usr/bin/fastfetch", "/usr/local/bin/"], check=True)
            subprocess.run(["sudo", "chmod", "+x", "/usr/local/bin/fastfetch"], check=True)

            # Clean up
            subprocess.run(["rm", "-rf", "/tmp/fastfetch.tar.gz", "/tmp/fastfetch-linux-amd64"], check=True)

            logger.success("Fastfetch installed successfully!")
        except Exception:
            logger.error(f"Error installing Fastfetch: {traceback.format_exc()}")

    @staticmethod
    def _install_docker() -> None:
        logger.info("Installing Docker...")

        try:
            # Install required packages for Docker
            subprocess.run(["sudo", "apt", "install", "-y", "apt-transport-https", "ca-certificates", "curl", "gnupg", "lsb-release"], check=True)

            # Add Docker's official GPG key
            subprocess.run(["sudo", "mkdir", "-p", "/etc/apt/keyrings"], check=True)

            # Download and add Docker GPG key properly
            gpg_key = subprocess.run(["curl", "-fsSL", "https://download.docker.com/linux/ubuntu/gpg"], capture_output=True)
            with open("/tmp/docker.gpg", "wb") as f:
                f.write(gpg_key.stdout)
            subprocess.run(["sudo", "gpg", "--dearmor", "-o", "/etc/apt/keyrings/docker.gpg", "/tmp/docker.gpg"], check=True)
            subprocess.run(["rm", "/tmp/docker.gpg"], check=False)

            # Add Docker repository
            arch = subprocess.run(["dpkg", "--print-architecture"], capture_output=True, text=True).stdout.strip()
            ubuntu_codename = subprocess.run(["lsb_release", "-cs"], capture_output=True, text=True).stdout.strip()
            docker_repo = f"deb [arch={arch} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu {ubuntu_codename} stable"
            subprocess.run(["sudo", "tee", "/etc/apt/sources.list.d/docker.list"], input=docker_repo, text=True, check=True)
            subprocess.run(["sudo", "apt", "update"], check=True)

            # Install Docker packages
            subprocess.run(["sudo", "apt", "install", "-y", "docker-ce", "docker-ce-cli", "containerd.io", "docker-compose-plugin"], check=True)

            # Add user to docker group
            subprocess.run(["sudo", "usermod", "-aG", "docker", os.getenv("USER")], check=True)

            logger.success("Docker installed successfully!")
        except Exception:
            logger.error(f"Error installing Docker: {traceback.format_exc()}")


    @staticmethod
    def _install_nvm_nodejs() -> None:
        logger.info("Installing nvm and Node.js...")

        try:
            # Install nvm
            nvm_dir = os.path.expanduser("~/.nvm")
            if not os.path.exists(nvm_dir):
                # Download nvm installation script
                nvm_script = subprocess.run(["curl", "-o-", "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh"], capture_output=True, text=True)

                # Save and run the script
                with open("/tmp/nvm_install.sh", "w") as f:
                    f.write(nvm_script.stdout)
                subprocess.run(["bash", "/tmp/nvm_install.sh"], check=True)
                subprocess.run(["rm", "/tmp/nvm_install.sh"], check=False)

                # Source nvm and install Node.js
                nvm_script_path = os.path.expanduser("~/.nvm/nvm.sh")
                if os.path.exists(nvm_script_path):
                    # Use bash to source nvm and install Node.js
                    install_nodejs_cmd = f"source {nvm_script_path} && nvm install --lts && nvm use --lts && nvm alias default lts/*"
                    subprocess.run(["bash", "-c", install_nodejs_cmd], check=True)
                    logger.success("nvm and Node.js LTS installed successfully!")
            else:
                logger.info("nvm already installed")
        except Exception:
            logger.error(f"Error installing nvm/Node.js: {traceback.format_exc()}")

    @staticmethod
    def _install_homebrew() -> None:
        logger.info("Installing Homebrew...")

        try:
            # Download and install Homebrew
            brew_install_cmd = subprocess.run(["curl", "-fsSL", "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"], capture_output=True)
            with open("/tmp/brew_install.sh", "wb") as f:
                f.write(brew_install_cmd.stdout)
            subprocess.run(["/bin/bash", "/tmp/brew_install.sh"], check=True)
            subprocess.run(["rm", "/tmp/brew_install.sh"], check=False)

            logger.success("Homebrew installed successfully!")
        except Exception:
            logger.error(f"Error installing Homebrew: {traceback.format_exc()}")

    @staticmethod
    def _install_uv() -> None:
        logger.info("Installing uv (Python package manager)...")

        try:
            # Install uv
            uv_script = subprocess.run(["curl", "-LsSf", "https://astral.sh/uv/install.sh"], capture_output=True)
            with open("/tmp/uv_install.sh", "wb") as f:
                f.write(uv_script.stdout)
            subprocess.run(["bash", "/tmp/uv_install.sh"], check=True)
            subprocess.run(["rm", "/tmp/uv_install.sh"], check=False)

            # Add uv to PATH
            cargo_bin = os.path.expanduser("~/.cargo/bin")
            if os.path.exists(cargo_bin):
                subprocess.run(["export", f"PATH={cargo_bin}:$PATH"], shell=True, check=False)

            logger.success("uv installed successfully!")
        except Exception:
            logger.error(f"Error installing uv: {traceback.format_exc()}")

    @staticmethod
    def _setup_fish_shell() -> None:
        logger.info("Setting up Fish shell...")

        # Change default shell to fish
        try:
            subprocess.run(["chsh", "-s", "/usr/bin/fish"], check=True)
            logger.success("Default shell changed to fish!")
        except Exception:
            logger.error(f"Error changing shell to fish: {traceback.format_exc()}")

        # Install Fisher (Fish plugin manager)
        try:
            # First, remove any existing fisher files to avoid conflicts
            subprocess.run(["rm", "-f", "/home/huuloc/.config/fish/functions/fisher.fish"], check=False)
            subprocess.run(["rm", "-f", "/home/huuloc/.config/fish/completions/fisher.fish"], check=False)

            # Install Fisher
            subprocess.run(["fish", "-c", "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"], check=True)
            logger.success("Fisher installed successfully!")
        except Exception:
            logger.error(f"Error installing Fisher: {traceback.format_exc()}")

    @staticmethod
    def _install_oh_my_posh() -> None:
        logger.info("Installing Oh My Posh...")

        try:
            # Create bin directory if it doesn't exist
            home = os.path.expanduser("~")
            bin_dir = os.path.join(home, "bin")
            os.makedirs(bin_dir, exist_ok=True)

            # Download and install Oh My Posh to user bin directory
            install_script = subprocess.run(["curl", "-s", "https://ohmyposh.dev/install.sh"], capture_output=True)
            with open("/tmp/ohmyposh_install.sh", "wb") as f:
                f.write(install_script.stdout)
            subprocess.run(["bash", "/tmp/ohmyposh_install.sh"], check=True, cwd=home)
            subprocess.run(["rm", "/tmp/ohmyposh_install.sh"], check=False)

            # Ensure oh-my-posh is executable and in PATH
            oh_my_posh_path = os.path.join(bin_dir, "oh-my-posh")
            if os.path.exists(oh_my_posh_path):
                subprocess.run(["chmod", "+x", oh_my_posh_path], check=True)

            logger.success("Oh My Posh installed successfully!")
        except Exception:
            logger.error(f"Error installing Oh My Posh: {traceback.format_exc()}")

    @staticmethod
    def _configure_fastfetch() -> None:
        logger.info("Configuring Fastfetch...")

        # Create fastfetch config directory if it doesn't exist
        config_dir = os.path.expanduser("~/.config/fastfetch")
        os.makedirs(config_dir, exist_ok=True)

        # Basic fastfetch config
        config_content = '''
{
  "logo": {
    "type": "small"
  },
  "display": {
    "separator": " "
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "shell",
    "display",
    "de",
    "wm",
    "wmtheme",
    "theme",
    "icons",
    "font",
    "cursor",
    "terminal",
    "terminalfont",
    "cpu",
    "gpu",
    "memory",
    "disk",
    "locale",
    "localip",
    "publicip",
    "weather",
    "players",
    "song",
    "wifi",
    "battery",
    "poweradapter",
    "separator",
    "colors"
  ]
}
'''

        config_file = os.path.join(config_dir, "config.jsonc")
        try:
            with open(config_file, "w") as f:
                f.write(config_content)
            logger.success("Fastfetch configured successfully!")
        except Exception:
            logger.error(f"Error configuring Fastfetch: {traceback.format_exc()}")