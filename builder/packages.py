from utils.schemes import DistributionPackages, Packages

BASE = Packages(
	apt=DistributionPackages(
		common=[
			"git", "curl", "wget", "fish", "fastfetch", "neovim", "lsd", "bat", "tree",
			"python3-dev", "python3-pip", "python3-venv", "fzf", "ripgrep", "fd-find", "jq"
		]
	)
)