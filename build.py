#!/usr/bin/env python3
import os
import sys
import subprocess
from get_depends import get_full_package_list_with_dependencies


starting_location = os.path.dirname(os.path.realpath(__file__))


def build_and_install_package(package_name: str) -> None:
    print(f"Building {package_name}...")
    target_path = os.path.join(starting_location, package_name)
    os.chdir(target_path)
    try:
        process = subprocess.run(
            args=[
                "psp-makepkg",
                "-i",
                "--noconfirm",
            ],
            check=True,
        )
    except subprocess.CalledProcessError as exc:
        print(f"Building {package_name} failed with error: {exc}")
        sys.exit(1)
    print(f"Building {package_name} done")



def main() -> None:
    build_script_name = "PSPBUILD"
    package_lists = get_full_package_list_with_dependencies(build_script_name=build_script_name)
    for package_list in package_lists:
        for package in package_list.split(" "):
            build_and_install_package(package_name=package)



if __name__ == "__main__":
    main()
