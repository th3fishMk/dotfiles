#!/usr/bin/env python

from enum import Enum
import subprocess
import sys
from pathlib import Path

help_message = "Run this command with either `dnf` or `flatpak` to indicate a installation \n Example: \ninst dnf blender"


class PkgMng(Enum):
    dnf = "dnf"
    flatpak = "flatpak"


def install_dnf(package_names: list[str]):
    print(f"Installing the following package(s): {package_names}")
    commands = ["sudo", "dnf", "install", "-y", "-q"] + package_names
    p = subprocess.Popen(
        commands,
        stdin=None,
        stdout=None,
        stderr=None,
    )
    p.wait()

    if p.returncode == 0:
        log_install(PkgMng.dnf, package_names)


def log_install(manager: PkgMng, pkg: list[str]):
    home = Path.home()
    filename = ".installs-dnf" if manager == PkgMng.dnf else ".installs-flatpak"
    full_path = Path.joinpath(home, filename)
    print(f"Logging to {full_path}")
    pkg_list = "\n".join(str(x) for x in pkg)
    file = open(full_path, "a+")
    file.write(f"\n{pkg_list}")


def install_flatpak(package_names: list[str]):
    print(f"Installing the following package(s): {package_names}")
    commands = ["flatpak", "install", "flathub", "-y"] + package_names
    p = subprocess.Popen(
        commands,
        stdin=None,
        stdout=None,
        stderr=None,
    )
    p.wait()

    if p.returncode == 0:
        log_install(PkgMng.flatpak, package_names)


args = sys.argv
if len(args) <= 2:
    print(help_message)
    sys.exit()
match args[1]:
    case "dnf":
        install_dnf(args[2:])
    case "flatpak":
        install_flatpak(args[2:])
    case _:
        print(help_message)
