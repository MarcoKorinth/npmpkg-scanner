from os import path, mkdir
from shutil import rmtree
import subprocess
from sys import exit as sys_exit


class AppContext:
    def __init__(self) -> None:
        self.package_name: str | None = None
        self.package_dir: str | None = None
        self._script_dir = path.dirname(path.abspath(__file__))
        self.tests_dir = path.join(self._script_dir, "tests")
        self.queries_dir = path.join(self._script_dir, "queries")
        self.tmp_dir = path.join(self._script_dir, ".tmp")
        self.output_file: str | None = None
        self.output_format: str | None = None
        self.test = False
        self.force = False
        self.verbose = False

    def init_app(self):
        self._create_tmp_dir()

    def _create_tmp_dir(self):
        if path.exists(self.tmp_dir):
            rmtree(self.tmp_dir)
        mkdir(self.tmp_dir)

    def exit(self, exit_code=0):
        if path.exists(self.tmp_dir):
            rmtree(self.tmp_dir)
        sys_exit(exit_code)

    def exec(self, cmd: str, cwd: str | None = None):
        cwd = self._script_dir if cwd is None else cwd
        return subprocess.run(cmd,
                              shell=True,
                              capture_output=(not self.verbose),
                              cwd=cwd)
