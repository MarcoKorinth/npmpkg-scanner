from os import listdir
from os.path import isdir, join
import threading
import time

from termcolor import colored

from appcontext import AppContext
from codeql import CodeQLHelper


_passed_symbol = colored("\u2714", "green")
_failed_symbol = colored("\u2717", "red")


class TestRunner:
    def __init__(self, app_context: AppContext) -> None:
        self._app_context = app_context

    def run_all(self, thread_count=4):
        print("Running tests..")
        start = time.time()

        tests = [f for f in listdir(self._app_context.tests_dir) if isdir(join(self._app_context.tests_dir, f))]
        # distribute tests on threads
        thread_tests = [[] for _ in range(thread_count)]
        for (i, test) in enumerate(tests):
            thread_tests[i%thread_count].append(test)
        # start threads and join
        threads = [threading.Thread(target=self.run_tests, args=[tests]) for tests in thread_tests]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        test_duration = round(time.time() - start, 2)
        print(f"Finished {len(tests)} tests in {test_duration}s")

    def run_tests(self, tests):
        for test in tests:
            self.run_test(test)

    def run_test(self, test_name):
        self._app_context.package_dir = join(self._app_context.tests_dir, test_name)
        codeql_helper = CodeQLHelper(self._app_context)
        codeql_helper.generate_database()
        sarif_parser = codeql_helper.apply_queries()
        if sarif_parser is None:
            raise Exception(f"Error while applying queries for \"{test_name}\" test test")

        if sarif_parser.check_behavior(test_name):
            print(f"{_passed_symbol} {test_name} (passed)")
            if len(sarif_parser.get_behaviors()) != 1:
                print(f"\tMultiple behaviors detected ({str(sarif_parser.get_behaviors())})")
        else:
            print(f"{_failed_symbol} {test_name} (failed)")
            print(f"\tDetected behaviors: {str(sarif_parser.get_behaviors())}")
