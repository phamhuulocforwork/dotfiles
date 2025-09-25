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
            shutil.copytree(src=Path("./home/.config"), dst=home / ".config", dirs_exist_ok=True)

        # Copy bin files
        if os.path.exists("./home/bin"):
            shutil.copytree(src=Path("./home/bin"), dst=home / "bin", dirs_exist_ok=True)

        # Copy shell configurations
        if os.path.exists("./home/.bashrc"):
            shutil.copy(src=Path("./home/.bashrc"), dst=home / ".bashrc")

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
