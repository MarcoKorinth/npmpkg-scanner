import json

from markdown_pdf import MarkdownPdf, Section

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
        elif self.app_context.output_format == "markdown":
            self._generate_markdown()
        elif self.app_context.output_format == "pdf":
            self._generate_pdf()

    def _get_markdown(self) -> str:
        markdown = "# NPM package analysis\n\n"

        markdown += "## Summary\n\n"
        markdown += "The following behaviors were detected:\n\n"
        for behavior in self.sarif_parser.get_behaviors():
            properties = self.sarif_parser.get_behavior_properties(behavior)
            if properties is not None:
                markdown += f"- {properties["name"]} ({properties["id"]})\n"

        markdown += "\n## Behaviors\n\n"
        for behavior in self.sarif_parser.get_behaviors():
            properties = self.sarif_parser.get_behavior_properties(behavior)
            results = self.sarif_parser.get_behavior_results(behavior)
            if properties is not None and results is not None:
                markdown += f"### {properties["id"]}\n\n"
                markdown += f"**{properties["name"]}**\\\n"
                markdown += f"{properties["description"]}\n\n"

                for result in results:
                    for loc in result["locations"]:
                        markdown += f"In `{loc["file"]}` (line: {loc["line"]}):\n"
                    markdown += "\n```javascript\n"
                    markdown += f"{result["text"]}\n"
                    markdown += "```\n\n"

        return markdown

    def _generate_raw(self) -> None:
        with open(self._get_filename("json"), "w") as f:
            json.dump(self.sarif_parser.raw_data, f, indent=4)

    def _generate_json(self) -> None:
        with open(self._get_filename("json"), "w") as f:
            json.dump({"todo": "This is a placeholder for the json file format"}, f, indent=4)

    def _generate_markdown(self) -> None:
        with open(self._get_filename("md"), "w") as f:
            f.write(self._get_markdown())

    def _generate_pdf(self) -> None:
        markdown = self._get_markdown()
        pdf = MarkdownPdf()
        pdf.add_section(Section(markdown))
        pdf.save(self._get_filename("pdf"))
