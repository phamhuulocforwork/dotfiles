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
            subprocess.run(["fish", "-c", "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"], check=True)
            logger.success("Fisher installed successfully!")
        except Exception:
            logger.error(f"Error installing Fisher: {traceback.format_exc()}")

    @staticmethod
    def _install_oh_my_posh() -> None:
        logger.info("Installing Oh My Posh...")

        try:
            # Download and install Oh My Posh
            subprocess.run(["curl", "-s", "https://ohmyposh.dev/install.sh"], capture_output=True, text=True, check=True)
            subprocess.run(["bash", "-s", "--", "-t", "/usr/local/bin"], check=True)
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