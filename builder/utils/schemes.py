from dataclasses import dataclass, field
from typing import List

@dataclass
class DistributionPackages:
    common: List[str] = field(default_factory=list)

@dataclass
class Packages:
    apt: DistributionPackages = field(default_factory=DistributionPackages)

@dataclass
class NotInstalledPackages:
    apt: List[str] = field(default_factory=list)
