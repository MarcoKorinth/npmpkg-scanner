#!/usr/bin/env python3

from argparse import ArgumentParser
from appcontext import AppContext
from npmhelper import NPMHelper
from codeql import CodeQLHelper
from os import path


def main() -> None:
    app_context = AppContext()

    parser = ArgumentParser(
        prog=path.basename(__file__),
        description="Scans a given NPM-package's code for behaviors and generates a report.")

    parser.add_argument('-v', '--verbose', action="store_true", help="Print codeql messages to stdout")
    parser_group = parser.add_mutually_exclusive_group(required=True)
    parser_group.add_argument('-p', '--package', help="Name of an NPM package")
    parser_group.add_argument('-s', '--src', help="Path to the NPM-package to be scanned")

    args = vars(parser.parse_args())
    app_context.package_dir = args["src"]
    app_context.package_name = args["package"]
    app_context.verbose = args["verbose"]

    try:
        app_context.init_app()
        run(app_context)
    except KeyboardInterrupt:
        pass
    except Exception as e:
        print(e)
        print("\nApplication exited with errors")
        if not app_context.verbose:
            print("Try running with `--verbose` for more information")
        app_context.exit(1)
    finally:
        app_context.exit()


def run(app_context: AppContext):
    if app_context.package_name is not None:
        print(f"Downloading package {app_context.package_name}")
        npm_helper = NPMHelper(app_context)
        package_dir = npm_helper.download_package(app_context.package_name)
        if package_dir is None:
            raise Exception("Error while downloading npm package")
        app_context.package_dir = package_dir

    codeql_helper = CodeQLHelper(app_context)
    codeql_helper.generate_database()
    codeql_helper.apply_queries()


if __name__ == "__main__":
    main()
