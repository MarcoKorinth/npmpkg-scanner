from appcontext import AppContext
from os import listdir, makedirs
from os.path import isfile, join, exists
from shutil import rmtree
import tarfile


class NPMHelper:
    def __init__(self, app_context: AppContext) -> None:
        self.app_context = app_context
        self.project_path = join(app_context.tmp_dir, "jsproject")

    def download_package(self, name: str) -> (str | None):
        if exists(self.project_path):
            rmtree(self.project_path)
        makedirs(self.project_path)

        # download package
        process = self.app_context.exec(f"npm pack \"{name}\"", cwd=self.project_path)

        # extract package
        if process.returncode == 0:
            pkg_filename = [f for f in listdir(self.project_path) if isfile(join(self.project_path, f)) and f.index("tgz") > 0][0]
            tar = tarfile.open(join(self.project_path, pkg_filename))
            tar.extractall(self.project_path)
            tar.close()
            return join(self.project_path, "package")
