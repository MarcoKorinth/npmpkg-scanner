from functools import cache
import json


class SarifParser:
    def __init__(self, sarif_file: str) -> None:
        with open(sarif_file) as json_data:
            self.raw_data = json.load(json_data)
            self.run = self.raw_data["runs"][0]

    @cache
    def get_behaviors(self):
        results = self.run["results"]
        return [x["ruleId"] for x in results]

    def check_behavior(self, behavior):
        return behavior in self.get_behaviors()

    @cache
    def get_behavior_properties(self, behavior: str) -> dict[str, dict] | None:
        rules = self.run["tool"]["driver"]["rules"]
        items = map(lambda rule: (rule["id"], rule["properties"]), rules)
        behavior_properties = {k: v for k, v in list(items)}
        return behavior_properties.get(behavior)

    @cache
    def get_results(self) -> dict:
        items = [(
            result["ruleId"],
            {
                "text": result["message"]["text"],
                "locations": [{
                    "file": l["physicalLocation"]["artifactLocation"]["uri"],
                    "line": (lambda s, e: f"{s}-{e}" if s != e else s)(
                        l["physicalLocation"]["region"]["startLine"], 
                        l["physicalLocation"]["region"]["endLine"]
                    )
                } for l in result["locations"]]
            }
        ) for result in self.run["results"]]
        return {k: v for k, v in items}

    @cache
    def get_behavior_results(self, behavior: str) -> list[dict] | None:
        return [self.get_results()[behavior]] if behavior in self.get_results() else []
