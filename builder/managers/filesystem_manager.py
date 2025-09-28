import os
import shutil
import subprocess
from pathlib import Path

from loguru import logger

class FileSystemManager:
    @staticmethod
    def create_default_folders() -> None:
        logger.success("Starting the process of creating default directories")

        default_folders = [
            ".config",
            "Github",
            "bin",
        ]

        expanded_folders = [str(Path.home() / folder) for folder in default_folders]

        try:
            subprocess.run(["mkdir", "-p", *expanded_folders], check=True)
        except Exception:
            logger.error(
                f"Error creating default directories: {traceback.format_exc()}"
            )

        logger.success("The process of creating default directories is complete!")

    @staticmethod
    def copy_dotfiles() -> None:
        logger.success("Starting the process of copying dotfiles")
        home = Path.home()

        if os.path.exists("./home/.config"):
            for item in os.listdir("./home/.config"):
                src_path = Path("./home/.config") / item
                dst_path = home / ".config" / item
                if src_path.is_file():
                    shutil.copy2(src_path, dst_path)
                elif src_path.is_dir() and os.listdir(src_path):
                    shutil.copytree(src_path, dst_path, dirs_exist_ok=True)

        if os.path.exists("./home/bin"):
            shutil.copytree(src=Path("./home/bin"), dst=home / "bin", dirs_exist_ok=True)

        if os.path.exists("./home/.zshrc"):
            zshrc_dst = home / ".zshrc"
            # Remove existing file if it exists to ensure overwrite
            if zshrc_dst.exists():
                zshrc_dst.unlink()
            shutil.copy(src=Path("./home/.zshrc"), dst=zshrc_dst)

        if os.path.exists("./home/.zsh_aliases"):
            zsh_aliases_dst = home / ".zsh_aliases"
            if zsh_aliases_dst.exists():
                zsh_aliases_dst.unlink()
            shutil.copy(src=Path("./home/.zsh_aliases"), dst=zsh_aliases_dst)

        if os.path.exists("./home/.gitconfig"):
            gitconfig_dst = home / ".gitconfig"
            if gitconfig_dst.exists():
                gitconfig_dst.unlink()
            shutil.copy(src=Path("./home/.gitconfig"), dst=gitconfig_dst)

        logger.success("Dotfiles copied successfully!")

        # Set permissions
        for path in [home / ".config", home / "bin"]:
            if path.exists():
                try:
                    subprocess.run(["chmod", "-R", "700", str(path)], check=True)
                except Exception:
                    logger.error(
                        f"[!] Error while making {path} executable: {traceback.format_exc()}"
                    )
