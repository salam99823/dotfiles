import requests

import bs4
from bs4.element import re


def main():
    text = requests.get("https://yazi-rs.github.io/docs/plugins/utils").text
    soup: bs4.BeautifulSoup = (
        bs4.BeautifulSoup(text, "lxml")
        .find("article")
        .find("div", {"class": ["theme-doc-markdown", "markdown"]})
    )
    for code in soup("div", {"class": "codeBlockContent_BhwS"}):
        code.replace_with(
            "\n".join(
                line.text
                for line in code.find_all(
                    "span",
                    {"class": ["token-line"]},
                )
            )
        )
    return soup


def parse_args_doc(text):
    for arg in re.finditer(r"([\w_]+ - .+\n)+(\n)", text):
        print(arg)


def fields(soup, doc="doc"):
    def _str(t):
        return t.text.strip().replace("\u200b", "")

    fields, cls, fun = {}, None, None
    for tag in soup:
        last: dict = fields[cls][fun] if fun else fields[cls] if cls else {}
        match tag.name:
            case "h2":
                cls, fun = _str(tag), None
                fields[cls] = {
                    doc: "",
                    "props": "",
                }
            case "h3":
                fun = _str(tag("code")[0])
                fields[cls][fun] = {
                    "def": f"function {cls}.{fun} end",
                    doc: "",
                    "args": "",
                }
            case "p":
                last[doc] += f"\n{_str(tag)}"
            case "div":
                last[doc] += f"""\n```lua\n{
                    "\n".join(line for line in tag.text.split("\n"))
                    }\n```"""
            case "ul":
                last["args" if fun else "props"] += f"\n{_str(tag)}"
    return fields


if __name__ == "__main__":
    classes = fields(main())
    for name, v in classes.items():
        print(
            "\n--- ".join(line for line in v["doc"].split("\n")),
            "\n--- ".join(line for line in v["props"].split("\n")),
        )
        print("---@class", name, f"\n{name} = {name} or {{}}")
        for field, details in v.items():
            if field in ["props", "doc"]:
                continue
            print(
                "\n--- ".join(line for line in details["doc"].split("\n")),
                "\n--- ".join(line for line in details["args"].split("\n")),
            )
            print(f"{details['def']}")
