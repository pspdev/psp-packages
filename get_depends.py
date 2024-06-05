#!/usr/bin/env python3
import json
import os
import re
import sys
from dataclasses import dataclass, field


@dataclass
class Package:
    name: str
    path: str
    dependencies_as_strings: list[str]
    dependencies: list['Package'] = field(default_factory=list)

    def get_build_order(self) -> str:
        build_order = self.get_recursive_dependencies()
        build_order.append(self.name)

        # Clean up duplicates
        already_seen = []
        to_remove = []
        for i, dependency in enumerate(build_order):
            if dependency in already_seen:
                to_remove.append(i)
            already_seen.append(dependency)
        to_remove.reverse()
        for i in to_remove:
            build_order.pop(i)

        return " ".join(build_order)

    def get_recursive_dependencies(self) -> list[str]:
        return_value = self.dependencies_as_strings
        for dependency in self.dependencies:
            return_value = dependency.get_recursive_dependencies() + return_value;
        return return_value

def parse_dependencies_string(value: str) -> list[str]:
    """
    Create a list of dependencies from the values of the different depends variables in the PKGBUILD
    :param value: String of depends values of PKGBUILD
    :return: List of dependencies as strings
    """
    initial_package_names_found = re.findall(r"[\w\t \-]{2,}", value)
    return_value = []
    for package in initial_package_names_found:
        if ":" in package:
            package = package.split(":")[0]
        return_value.append(package)
    return return_value


def parse_pkgbuild(path: str):
    """
    Extract the name and dependencies out of a build script
    :param path: path of the build script
    :return: a Package object with name, path and dependencies_as_strings set
    """
    in_function = False
    current_entry = ""
    current_value = ""
    name = ""
    dependencies_string = ""
    with open(path, "r") as pkgbuild:
        for line in pkgbuild.readlines():
            if not line or line in [" ", "\n", " \n"]:
                continue
            if not in_function:
                if re.match(r"^[a-z]+ *=.*", line):
                    current_entry, current_value = line.replace("\n", "").split("=", 1)
                elif re.match(r" *[a-z]+ *\( *\) *\{.*", line):
                    in_function = True
                # Read values we need
                if not in_function and current_entry:
                    if current_entry == "pkgname":
                        name = current_value
                    if current_entry in ["depends", "makedepends", "optdepends"]:
                        dependencies_string += current_value
            elif re.match(r"(.*;)? *}", line):
                in_function = False

    return Package(
        name=name,
        path=path,
        dependencies_as_strings=parse_dependencies_string(dependencies_string)
    )


def resolve_package_dependencies(current_package: Package, packages: list[Package]) -> None:
    """
    Fills out dependencies in a package based on the package names in dependencies_as_string
    :param current_package: The package to set the dependencies of
    :param packages: List of all packages
    """
    for package in packages:
        if package.name in current_package.dependencies_as_strings:
            current_package.dependencies.append(package)


def main() -> None:
    build_script_name = "PSPBUILD"
    if len(sys.argv) == 2:
        build_script_name = sys.argv[1]

    packages = []
    for directory in os.listdir():
        PKGBUILD = os.path.join(directory, build_script_name)
        if os.path.isdir(directory) and os.path.exists(PKGBUILD):
            package = parse_pkgbuild(PKGBUILD)
            packages.append(package)

    for package in packages:
        resolve_package_dependencies(current_package=package, packages=packages)

    build_orders = []
    for package in packages:
        build_order = package.get_build_order()
        build_orders.append(build_order)

    print(json.dumps(build_orders))


if __name__ == '__main__':
    main()
