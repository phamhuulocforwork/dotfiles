import subprocess
from typing import List

from loguru import logger

class PackageManager:
    @staticmethod
    def install_package(package: str, error_retries: int = 3) -> bool:
        """Installs the package with apt

        Args:
            package (str): Name of the package to be installed
            error_retries (int, optional): How many times will the function attempt to install the package. Defaults to 3.

        Returns:
            bool: Status, whether the package is installed or not
        """

        # Check if package is already installed
        try:
            result = subprocess.run(
                ["dpkg", "-l", package],
                capture_output=True,
                text=True,
                check=True
            )
            if "ii" in result.stdout:
                logger.info(f'Package "{package}" is already installed')
                return True
        except subprocess.CalledProcessError:
            pass  # Package not installed, continue with installation

        for _ in range(error_retries):
            try:
                subprocess.run(
                    ["sudo", "apt", "install", "-y", package],
                    check=True,
                )
                logger.success(f'Package "{package}" has been successfully installed!')
                return True
            except Exception:
                logger.error(f'Error while installing package "{package}"')

            continue

        return False

    @staticmethod
    def install_packages(packages_list: List[str]) -> List[str]:
        """Installs a lot of packages via apt

        Args:
            packages_list (List[str]): List of package names

        Returns:
            List[str]: List of packages that could not be installed
        """
        not_installed_packages = []

        for package in packages_list:
            installed = PackageManager.install_package(package=package)

            if not installed:
                not_installed_packages.append(package)

        return not_installed_packages
