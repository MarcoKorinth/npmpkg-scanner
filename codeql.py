from os import path
from uuid import uuid4

from appcontext import AppContext
from sarifparser import SarifParser


class CodeQLHelper:
    def __init__(self, app_context: AppContext) -> None:
        self._app_context = app_context
        self.helper_id = str(uuid4())
        self.database_dir = path.join(self._app_context.tmp_dir, f"codeql_database_{self.helper_id}")
        self.database_generated = False

    def generate_database(self) -> bool:
        process = self._app_context.exec(
            f"codeql database create --language=javascript " +
            f"--source-root=\"{self._app_context.package_dir}\" " +
            f"{self.database_dir}")

        if process.returncode == 0:
            self.database_generated = True
            return True
        else:
            print("Error while generating CodeQL database")

        return False

    def apply_queries(self) -> (SarifParser | None):
        if not self.database_generated:
            raise Exception("Error! Cannot apply queries, database has not been generated yet.")

        output = path.join(self._app_context.tmp_dir, f"{self.helper_id}.json")
        process = self._app_context.exec(f"codeql database analyze " +
            f"--format=sarifv2.1.0 --output={output} --threads=-2 " +
            f"-- {self.database_dir} {self._app_context.queries_dir}")

        if process.returncode == 0:
            return SarifParser(output)
