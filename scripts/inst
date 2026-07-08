#!/usr/bin/env python

import subprocess
import sys
from pathlib import Path

help_message = "Run this command with either `dnf` or `flatpak` to indicate a installation \n Example: \ninst dnf blender"


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
        log_install(package_names)


def log_install(pkg: list[str]):
    home = Path.home()
    filename = ".install-log"
    full_path = Path.joinpath(home, filename)
    print(f"Logging to {full_path}")
    pkg_list = "\n".join(str(x) for x in pkg)
    file = open(full_path, "a+")
    file.write(f"\n{pkg_list}")


def install_flatpak(pkg):
    print(
        "This functionality is not implemented yet, please dont have an emergency at this location."
    )
    sys.exit()


args = sys.argv
if len(args) <= 2:
    print(help_message)
    sys.exit()
match args[1]:
    case "dnf":
        install_dnf(args[2:])
    case "flatpak":
        install_flatpak(args[2:])

# TODO: Implement flatpak installation
# TODO: Implement multiple packages installation
