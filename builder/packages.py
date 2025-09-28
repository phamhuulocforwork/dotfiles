from utils.schemes import DistributionPackages, Packages

BASE = Packages(
	apt=DistributionPackages(
		common=[
			"git", "curl", "wget", "zsh", "neovim", "lsd", "bat", "tree", "unzip",
			"python3-dev", "python3-pip", "python3-venv", "fzf", "ripgrep", "fd-find", "jq",
			"apt-transport-https", "ca-certificates", "gnupg", "lsb-release", "build-essential",
			"software-properties-common", "ca-certificates", "curl", "gnupg", "lsb-release"
		]
	)
)