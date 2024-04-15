from appcontext import AppContext
from os import path


class CodeQLHelper:
    def __init__(self, app_context: AppContext) -> None:
        self.app_context = app_context
        self.database_dir = path.join(self.app_context.tmp_dir, 'codeql_database')
        self.database_generated = False

    def generate_database(self) -> bool:
        print("Generating CodeQL database")
        process = self.app_context.exec(
            f"codeql database create --language=javascript " +
            f"--source-root={self.app_context.package_dir} " +
            f"-- {self.database_dir}")

        if process.returncode == 0:
            self.database_generated = True
            print("Database generated successfully")
            return True
        else:
            print("Error while generating CodeQL database")

        return False
