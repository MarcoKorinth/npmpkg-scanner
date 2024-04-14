#!/usr/bin/env python3

from argparse import ArgumentParser
from os import path, mkdir
from shutil import rmtree
from sys import exit as sys_exit


class AppContext:
    def __init__(self) -> None:
        self.APPNAME = "Summary generator"
        self.package_dir = ""
        self._script_dir = path.dirname(path.abspath(__file__))
        self.tmp_dir = path.join(self._script_dir, ".tmp")
        self.verbose = False

    def init_app(self):
        self._create_tmp_dir()

    def _create_tmp_dir(self):
        if not path.exists(self.tmp_dir):
            mkdir(self.tmp_dir)

    def exit(self, exit_code=0):
        if path.exists(self.tmp_dir):
            rmtree(self.tmp_dir)
        sys_exit(exit_code)


def main() -> None:
    app_context = AppContext()

    parser = ArgumentParser(
        prog=app_context.APPNAME,
        description="Scans a given NPM-package's code for behaviors and generates a report.")

    parser.add_argument('-v', '--verbose', action="store_true", help="Print codeql messages to stdout")
    parser_group = parser.add_mutually_exclusive_group(required=True)
    parser_group.add_argument('-p', '--package', help="Name of an NPM package")
    parser_group.add_argument('-s', '--src', help="Path to the NPM-package to be scanned")

    args = vars(parser.parse_args())
    app_context.verbose = args["verbose"]
    app_context.package_dir = args["package"]

    try:
        app_context.init_app()
        # TODO: app logic
    except KeyboardInterrupt:
        pass
    except:
        print("Application exited with errors")
        if not app_context.verbose:
            print("Try running with `--verbose` for more information")
        app_context.exit(1)
    finally:
        app_context.exit()

if __name__ == "__main__":
        main()
