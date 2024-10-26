#!/usr/bin/env python3

from argparse import ArgumentParser
from datetime import datetime
from os import path

from appcontext import AppContext
from codeql import CodeQLHelper
from npmhelper import NPMHelper
from outputgenerator import OutputGenerator
from testrunner import TestRunner


def main() -> None:
    app_context = AppContext()

    parser = ArgumentParser(
        prog=path.basename(__file__),
        description="Scans a given NPM-package's code for behaviors and generates a report.")

    parser_package = parser.add_mutually_exclusive_group(required=True)
    parser_package.add_argument('-p', '--package', help="name of an NPM package")
    parser_package.add_argument('-s', '--src', help="path to the NPM-package to be scanned")
    parser_package.add_argument('-t', '--test', action="store_true", help="run tests")

    timestamp = datetime.today().strftime("%Y-%m-%d_%H-%M")
    parser.add_argument('-o', '--output', default=f"report_{timestamp}", help="name of the generated file")
    parser.add_argument('-f', '--format', choices=["raw", "markdown", "pdf"], default="markdown", help="format of the generated file")
    parser.add_argument('--force', action="store_true", help="override output file if it already exists")
    parser.add_argument('-v', '--verbose', action="store_true", help="print codeql messages to stdout")

    args = vars(parser.parse_args())
    app_context.package_dir = args["src"]
    app_context.package_name = args["package"]
    app_context.output_file = args["output"]
    app_context.output_format = args["format"]
    app_context.test = args["test"]
    app_context.force = args["force"]
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
    if app_context.test:
        test_runner = TestRunner(app_context)
        test_runner.run_all()
        return

    if (app_context.output_file
        and path.exists(app_context.output_file)
        and not app_context.force):
        raise Exception("Error! Output file already exists. Use --force to override")

    if app_context.package_name is not None:
        print(f"Downloading package {app_context.package_name}..")
        npm_helper = NPMHelper(app_context)
        package_dir = npm_helper.download_package(app_context.package_name)
        if package_dir is None:
            raise Exception("Error while downloading npm package")
        app_context.package_dir = package_dir

    codeql_helper = CodeQLHelper(app_context)
    print("Generating CodeQL database..")
    codeql_helper.generate_database()
    print("Database generated successfully")
    print("Applying CodeQL queries to database..")
    sarif_parser = codeql_helper.apply_queries()

    if sarif_parser is not None:
        print("Queries applied successfully")
        print("Generating outputfile..")
        output_generator = OutputGenerator(app_context, sarif_parser)
        output_generator.generate_outputfile()


if __name__ == "__main__":
    main()
