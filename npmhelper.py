from appcontext import AppContext
import json
from os import makedirs
from os.path import join, exists
from shutil import rmtree


class NPMHelper:
    def __init__(self, app_context: AppContext) -> None:
        self.app_context = app_context
        self.project_path = join(app_context.tmp_dir, "jsproject")

    def download_package(self, name: str) -> (str | None):
        if exists(self.project_path):
            rmtree(self.project_path)

        makedirs(self.project_path)
        # create empty project
        with open(join(self.project_path, "package.json"), "w") as package_json:
            package_json.write(json.dumps({
                "name": "temporary_project",
                "version": "1.0.0"
            }))
        # download package with npm
        process = self.app_context.exec(f"npm install --ignore-scripts --omit=optional \"{name}\"", cwd=self.project_path)
        if process.returncode == 0:
            return join(self.project_path, f"node_modules/{name}")

        return
