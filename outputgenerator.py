import json

from appcontext import AppContext
from sarifparser import SarifParser


class OutputGenerator:
    def __init__(self, app_context: AppContext, sarif_parser: SarifParser) -> None:
        self.app_context = app_context
        self.sarif_parser = sarif_parser

    def _get_filename(self, extension: str) -> str:
        assert self.app_context.output_file is not None

        if self.app_context.output_file.endswith(f".{extension}"):
            return self.app_context.output_file
        return f"{self.app_context.output_file}.{extension}"

    def generate_outputfile(self) -> None:
        if self.app_context.output_format == "raw":
            self._generate_raw()
        elif self.app_context.output_format == "json":
            self._generate_json()

    def _generate_raw(self) -> None:
        with open(self._get_filename("json"), "w") as f:
            json.dump(self.sarif_parser.raw_data, f, indent=4)

    def _generate_json(self) -> None:
        with open(self._get_filename("json"), "w") as f:
            json.dump({"todo": "This is a placeholder for the json file format"}, f, indent=4)
