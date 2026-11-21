#!/usr/bin/python3
import glob
import json
import os
import re
import sys
from typing import Text

TRANSLATIONS = {
    "Mod1": "Alt",
    "Mod2": "",
    "Mod3": "󰘲",
    "Mod4": "",
    "Mod5": "Scroll",
    "question": "?",
    "space": "␣",
    "minus": "-",
    "plus": "+",
    "Return": "󰌑",
    "XF86AudioRaiseVolume": "󰝝",
    "XF86AudioLowerVolume": "󰝞",
    "XF86AudioMute": "󰝟",
    "XF86AudioMicMute": "󰍭",
    "XF86MonBrightnessUp": "󰃠",
    "XF86MonBrightnessDown": "󰃞",
    "XF86PowerOff": "󰐥",
    "XF86TouchpadToggle": "Toggle Touchpad",
}


def replace_binding_from_map(binding: Text, dictionary: dict) -> Text:
    def translate(word: Text, dictionary: dict):
        try:
            return dictionary[word]
        except KeyError:
            return word

    return " + ".join(
        translate(translate(element.strip(), dictionary), TRANSLATIONS)
        for element in binding.split("+")
    )


_DOCS_LINE_REGEX = (
    r"^## (?P<category>.+?) // (?P<action>.+?)\s+(// (?P<keybinding>.+?))*##"
)


def get_docs(lines: list) -> list:
    symbol_dict = {
        match.group("variable"): match.group("value")
        for match in map(
            lambda line: re.match(
                r"^set\s+(?P<variable>\$.+?)\s(?P<value>.+)?",
                line,
            ),
            lines,
        )
        if match and match.group("variable")
    }

    configs: list = []
    for index, match in enumerate(
        map(
            lambda line: re.match(
                _DOCS_LINE_REGEX,
                line,
            ),
            lines,
        )
    ):
        if not match:
            continue
        config = {
            "category": match.group("category"),
            "action": match.group("action"),
            "keybinding": match.group("keybinding"),
        }
        if config["keybinding"] is None:
            config["keybinding"] = lines[index + 1].split(" ")[1]
        config["keybinding"] = replace_binding_from_map(
            config["keybinding"],
            symbol_dict,
        )
        configs.append(config)
    return configs


def read_file(path: str) -> list:
    try:
        paths = glob.glob(path)
    except Exception:
        print("couldn't resolve glob:", path, file=sys.stderr)
        paths = []
    lines: list[str] = []
    for path in paths:
        with open(path, "r") as file:
            file_lines = file.readlines()
        for line in file_lines:
            nextPath = re.match(r"^include\s+(.+?)$", line)
            if nextPath is None:
                lines.append(line)
                continue
            lines.extend(
                read_file(
                    os.path.expandvars(nextPath.group(1)),
                )
            )
    return lines


def main():
    if len(sys.argv) >= 2:
        rootPath = sys.argv[1]
    else:
        rootPath = "/etc/sway/config"
    lines = read_file(rootPath)
    docsList = get_docs(lines)
    print(json.dumps(docsList))


if __name__ == "__main__":
    main()
