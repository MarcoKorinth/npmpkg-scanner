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
        print("Running benchmark tests..")
        start = time.time()

        benchmarks = [f for f in listdir(self._app_context.benchmarks_dir) if isdir(join(self._app_context.benchmarks_dir, f))]
        # distribute tests on threads
        thread_benchmarks = [[] for _ in range(thread_count)]
        for (i, benchmark) in enumerate(benchmarks):
            thread_benchmarks[i%thread_count].append(benchmark)
        # start threads and join
        threads = [threading.Thread(target=self.run_tests, args=[benchmarks]) for benchmarks in thread_benchmarks]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        test_duration = round(time.time() - start, 2)
        print(f"Finished {len(benchmarks)} benchmarks in {test_duration}s")

    def run_tests(self, benchmarks):
        for benchmark in benchmarks:
            self.run_test(benchmark)

    def run_test(self, benchmark_name):
        self._app_context.package_dir = join(self._app_context.benchmarks_dir, benchmark_name)
        codeql_helper = CodeQLHelper(self._app_context)
        codeql_helper.generate_database()
        sarif_parser = codeql_helper.apply_queries()
        if sarif_parser is None:
            raise Exception(f"Error while applying queries for \"{benchmark_name}\" benchmark test")

        if sarif_parser.check_behavior(benchmark_name):
            print(f"{_passed_symbol} {benchmark_name} (passed)")
            if len(sarif_parser.get_behaviors()) != 1:
                print(f"\tWarning! Multiple behaviors detected ({str(sarif_parser.get_behaviors())})")
        else:
            print(f"{_failed_symbol} {benchmark_name} (failed)")
            print(f"\tDetected behaviors: {str(sarif_parser.get_behaviors())}")
