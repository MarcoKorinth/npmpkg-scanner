from appcontext import AppContext
from os import path


class CodeQLHelper:
    def __init__(self, app_context: AppContext) -> None:
        self._app_context = app_context
        self.database_dir = path.join(self._app_context.tmp_dir, 'codeql_database')
        self.database_generated = False
        self.report_file = path.join(self._app_context.tmp_dir, "codeql_report.json")

    def generate_database(self) -> bool:
        print("Generating CodeQL database..")
        process = self._app_context.exec(
            f"codeql database create --language=javascript " +
            f"--source-root={self._app_context.package_dir} " +
            f"-- {self.database_dir}")

        if process.returncode == 0:
            self.database_generated = True
            print("Database generated successfully")
            return True
        else:
            print("Error while generating CodeQL database")

        return False

    def apply_queries(self):
        if not self.database_generated:
            print("Error! Cannot apply queries, database has not been generated yet.")
            return

        print("Applying CodeQL queries to database..")
        process = self._app_context.exec(f"codeql database analyze {self.database_dir} " +
            f"--format=csv --output={self.report_file} {self._app_context.queries_dir}")

        if process.returncode == 0:
            print("Queries applied successfully")
