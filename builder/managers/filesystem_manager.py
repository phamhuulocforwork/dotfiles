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

        ##==> Copying dotfiles
        ##############################################

        # Copy config files
        if os.path.exists("./home/.config"):
            # Copy config directory, but skip empty directories that might cause conflicts
            for item in os.listdir("./home/.config"):
                src_path = Path("./home/.config") / item
                dst_path = home / ".config" / item
                if src_path.is_file():
                    # Copy individual files
                    shutil.copy2(src_path, dst_path)
                elif src_path.is_dir() and os.listdir(src_path):
                    # Only copy non-empty directories
                    shutil.copytree(src_path, dst_path, dirs_exist_ok=True)

        if os.path.exists("./home/bin"):
            shutil.copytree(src=Path("./home/bin"), dst=home / "bin", dirs_exist_ok=True)

        if os.path.exists("./home/.zshrc"):
            shutil.copy(src=Path("./home/.zshrc"), dst=home / ".zshrc")

        if os.path.exists("./home/.zsh_aliases"):
            shutil.copy(src=Path("./home/.zsh_aliases"), dst=home / ".zsh_aliases")

        if os.path.exists("./home/.gitconfig"):
            shutil.copy(src=Path("./home/.gitconfig"), dst=home / ".gitconfig")

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
