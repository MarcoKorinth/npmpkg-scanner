import json


class SarifParser:
    def __init__(self, sarif_file: str) -> None:
        with open(sarif_file) as json_data:
            self.raw_data = json.load(json_data)

    def get_behaviors(self):
        results = self.raw_data["runs"][0]["results"]
        return [x["ruleId"] for x in results]

    def check_behavior(self, behavior):
        return behavior in self.get_behaviors()
