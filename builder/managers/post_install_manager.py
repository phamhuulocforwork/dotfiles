import glob
import os
import subprocess
import traceback

from loguru import logger

class PostInstallation:
    @staticmethod
    def apply():
        logger.info("The post-installation configuration is starting...")
        PostInstallation._install_fastfetch()
        PostInstallation._setup_zsh_shell()
        PostInstallation._install_docker()
        PostInstallation._install_nvm_nodejs()
        PostInstallation._install_homebrew()
        PostInstallation._install_uv()
        PostInstallation._install_oh_my_zsh()
        logger.info("The post-installation configuration is complete!")

    @staticmethod
    def _install_fastfetch() -> None:
        try:
            fastfetch_url = "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz"
            subprocess.run(["curl", "-L", "-o", "/tmp/fastfetch.tar.gz", fastfetch_url], check=True)

            subprocess.run(["tar", "-xzf", "/tmp/fastfetch.tar.gz", "-C", "/tmp"], check=True)

            user_bin_dir = os.path.expanduser("~/.local/bin")
            os.makedirs(user_bin_dir, exist_ok=True)

            subprocess.run(["cp", "/tmp/fastfetch-linux-amd64/usr/bin/fastfetch", user_bin_dir], check=True)
            subprocess.run(["chmod", "+x", os.path.join(user_bin_dir, "fastfetch")], check=True)

            zshrc_path = os.path.expanduser("~/.zshrc")
            bashrc_path = os.path.expanduser("~/.bashrc")
            path_export = 'export PATH="$HOME/.local/bin:$PATH"'

            for rc_file in [bashrc_path, zshrc_path]:
                if os.path.exists(rc_file):
                    with open(rc_file, 'r') as f:
                        content = f.read()
                    if path_export not in content:
                        with open(rc_file, 'a') as f:
                            f.write(f'\n{path_export}\n')

            subprocess.run(["rm", "-rf", "/tmp/fastfetch.tar.gz", "/tmp/fastfetch-linux-amd64"], check=True)

            config_dir = os.path.expanduser("~/.config/fastfetch")
            os.makedirs(config_dir, exist_ok=True)

        except Exception:
            logger.error(f"Error installing Fastfetch: {traceback.format_exc()}")

    @staticmethod
    def _install_docker() -> None:
        try:
            try:
                subprocess.run(["docker", "--version"], capture_output=True, check=True)
                return
            except subprocess.CalledProcessError:
                pass

            # Docker requires sudo and complex setup - skip in automated setup
            logger.warning("Docker installation requires sudo privileges and is skipped in automated setup.")
            logger.warning("Please install Docker manually using Docker Desktop for WSL or run:")
            logger.warning("curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh")

        except Exception:
            logger.error(f"Error checking Docker installation: {traceback.format_exc()}")


    @staticmethod
    def _install_nvm_nodejs() -> None:
        try:
            nvm_dir = os.path.expanduser("~/.nvm")
            if not os.path.exists(nvm_dir):
                nvm_script = subprocess.run(["curl", "-o-", "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh"], capture_output=True, text=True)

                with open("/tmp/nvm_install.sh", "w") as f:
                    f.write(nvm_script.stdout)
                subprocess.run(["bash", "/tmp/nvm_install.sh"], check=True)
                subprocess.run(["rm", "/tmp/nvm_install.sh"], check=False)

                nvm_script_path = os.path.expanduser("~/.nvm/nvm.sh")
                if os.path.exists(nvm_script_path):
                    install_nodejs_cmd = f"source {nvm_script_path} && nvm install --lts && nvm use --lts && nvm alias default lts/*"
                    subprocess.run(["bash", "-c", install_nodejs_cmd], check=True)
            else:
                logger.info("nvm already installed")
        except Exception:
            logger.error(f"Error installing nvm/Node.js: {traceback.format_exc()}")

    @staticmethod
    def _install_homebrew() -> None:
        try:
            brew_install_cmd = subprocess.run(["curl", "-fsSL", "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"], capture_output=True)
            with open("/tmp/brew_install.sh", "wb") as f:
                f.write(brew_install_cmd.stdout)
            subprocess.run(["/bin/bash", "/tmp/brew_install.sh"], check=True)
            subprocess.run(["rm", "/tmp/brew_install.sh"], check=False)
        except Exception:
            logger.error(f"Error installing Homebrew: {traceback.format_exc()}")

    @staticmethod
    def _install_uv() -> None:
        try:
            uv_script = subprocess.run(["curl", "-LsSf", "https://astral.sh/uv/install.sh"], capture_output=True)
            with open("/tmp/uv_install.sh", "wb") as f:
                f.write(uv_script.stdout)
            subprocess.run(["bash", "/tmp/uv_install.sh"], check=True)
            subprocess.run(["rm", "/tmp/uv_install.sh"], check=False)

            cargo_bin = os.path.expanduser("~/.cargo/bin")
            if os.path.exists(cargo_bin):
                subprocess.run(["export", f"PATH={cargo_bin}:$PATH"], shell=True, check=False)
        except Exception:
            logger.error(f"Error installing uv: {traceback.format_exc()}")

    @staticmethod
    def _setup_zsh_shell() -> None:
        try:
            current_shell = os.path.basename(os.environ.get('SHELL', ''))
            if current_shell == 'zsh':
                return

            subprocess.run(["chsh", "-s", "/usr/bin/zsh"], check=True)
        except subprocess.CalledProcessError:
            logger.warning("Could not change default shell automatically.")
            logger.warning("Please run 'chsh -s /usr/bin/zsh' manually after setup completes.")
        except Exception:
            logger.error(f"Error changing shell to zsh: {traceback.format_exc()}")

        try:
            zsh_dir = os.path.expanduser("~/.oh-my-zsh")
            plugins_dir = os.path.join(zsh_dir, "plugins")
            os.makedirs(plugins_dir, exist_ok=True)

            autosuggestions_dir = os.path.join(plugins_dir, "zsh-autosuggestions")
            if not os.path.exists(autosuggestions_dir):
                subprocess.run(["git", "clone", "https://github.com/zsh-users/zsh-autosuggestions.git", autosuggestions_dir], check=True)

            syntax_highlighting_dir = os.path.join(plugins_dir, "zsh-syntax-highlighting")
            if not os.path.exists(syntax_highlighting_dir):
                subprocess.run(["git", "clone", "https://github.com/zsh-users/zsh-syntax-highlighting.git", syntax_highlighting_dir], check=True)
        except Exception:
            logger.error(f"Error installing zsh plugins: {traceback.format_exc()}")

    @staticmethod
    def _install_oh_my_zsh() -> None:
        try:
            oh_my_zsh_dir = os.path.expanduser("~/.oh-my-zsh")
            oh_my_zsh_script = os.path.join(oh_my_zsh_dir, "oh-my-zsh.sh")

            if not os.path.exists(oh_my_zsh_script):
                if os.path.exists(oh_my_zsh_dir):
                    subprocess.run(["rm", "-rf", oh_my_zsh_dir], check=True)

                install_cmd = 'curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended'
                subprocess.run(install_cmd, shell=True, check=True, executable="/bin/bash")
            else:
                logger.info("Oh My Zsh already installed")

            try:
                themes_dir = os.path.expanduser("~/.oh-my-zsh/themes")
                catppuccin_dir = os.path.expanduser("~/catppuccin-zsh")

                if not os.path.exists(catppuccin_dir):
                    subprocess.run(["git", "clone", "https://github.com/JannoTjarks/catppuccin-zsh.git", catppuccin_dir], check=True)

                theme_source = os.path.join(catppuccin_dir, "catppuccin.zsh-theme")
                theme_dest = os.path.join(themes_dir, "catppuccin.zsh-theme")

                if os.path.exists(theme_source):
                    with open(theme_source, 'r') as f:
                        theme_content = f.read()

                    theme_content = theme_content.replace(
                        '${0:A:h}/catppuccin-flavors/',
                        f'{catppuccin_dir}/catppuccin-flavors/'
                    )

                    with open(theme_dest, 'w') as f:
                        f.write(theme_content)
            except Exception:
                logger.error(f"Error installing Catppuccin theme: {traceback.format_exc()}")

        except Exception:
            logger.error(f"Error installing Oh My Zsh: {traceback.format_exc()}")