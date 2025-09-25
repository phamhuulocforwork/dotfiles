from loguru import logger
from managers.filesystem_manager import FileSystemManager
from managers.package_manager import PackageManager
from managers.post_install_manager import PostInstallation
from packages import BASE
from utils.schemes import NotInstalledPackages

class Builder:
    not_installed_packages = NotInstalledPackages()

    def run(self) -> None:
        logger.success(
            "The program has been launched successfully. Starting WSL Ubuntu terminal setup."
        )

        # Create default folders
        FileSystemManager.create_default_folders()

        # Install packages
        self.packages_installation()

        # Copy dotfiles
        FileSystemManager.copy_dotfiles()

        # Post installation setup
        PostInstallation.apply()

        logger.success("WSL Ubuntu terminal setup is complete!")

    def packages_installation(self) -> None:
        logger.info("Starting the package installation process")
        apt_packages = []

        apt_packages.extend(BASE.apt.common)

        self.not_installed_packages.apt.extend(
            PackageManager.install_packages(apt_packages)
        )

        logger.success("The installation process of all packages is complete!")

if __name__ == "__main__":
    logger.add(
        sink="build_debug.log",
        format="{time} | {level} | {message}",
        level="DEBUG",
        encoding="utf-8",
    )

    builder = Builder()
    builder.run()
