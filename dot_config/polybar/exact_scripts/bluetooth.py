import argparse
import re
import shutil
import subprocess
from enum import StrEnum
from typing import overload


class Filters(StrEnum):
    Paired = "Paired"
    Bounded = "Bounded"
    Trusted = "Trusted"
    Connected = "Connected"
    none = ""


class Bluetoothctl:
    ControllerRegex = re.compile(
        r"^Controller (?P<mac>(?::?[0-9A-F]{2})+) (?P<name>.+?)"
        r"(?P<default> \[default\])?$",
    )
    DeviceRegex = re.compile(
        r"^Device (?P<mac>(?::?[0-9A-F]{2})+) (?P<name>.+)$",
    )
    InfoRegex = re.compile(
        r"^\t(?P<key>[\w\s]+): (?P<value>.+)$",
    )

    def __init__(self):
        if shutil.which("bluetoothctl") is None:
            raise EnvironmentError("bluetoothctl missing")

    def __call__(self, *args: str) -> str:
        return subprocess.check_output(("bluetoothctl", *args)).decode()

    @overload
    def show(self, ctrl: str = "") -> str: ...
    @overload
    def show(self, ctrl: dict[str, str]) -> dict[str, str]: ...

    def show(self, ctrl=""):
        if isinstance(ctrl, str):
            return self("show", ctrl)
        return self.parse_info(self("show", ctrl.get("mac", "")))

    @overload
    def info(self, dev: str = "") -> str: ...
    @overload
    def info(self, dev: dict[str, str]) -> dict[str, str]: ...

    def info(self, dev=""):
        if isinstance(dev, str):
            return self("info", dev)
        return self.parse_info(self("info", dev.get("mac", "")))

    def parse_info(self, info: str) -> dict[str, str]:
        result = {}
        for line in info.splitlines():
            match = self.InfoRegex.match(line)
            if match is None:
                continue
            key, value = match.group("key").lower(), match.group("value")
            if key in result:
                result[key] = ""
                continue
            result[key] = value
        return {key: value for key, value in result.items() if value}

    def list(self):
        return (
            {
                "mac": m.group("mac"),
                "name": m.group("name"),
                "default": bool(m.group("default")),
            }
            for m in self.ControllerRegex.finditer(self("list"))
        )

    def devices(self, filter: Filters = Filters.none):
        return (
            {"mac": m.group("mac"), "name": m.group("name")}
            for m in self.DeviceRegex.finditer(self("devices", filter))
        )

    def controller(self):
        for ctrl in self.list():
            if ctrl["default"]:
                return ctrl


def main(online: str, offline: str, connected: str, icons: str):
    bluetoothctl = Bluetoothctl()
    controller = bluetoothctl.controller()
    if controller is None:
        return ""
    info = bluetoothctl.show(controller)
    if info.get("powered") == "no":
        return offline.format(**info)
    for device in map(
        bluetoothctl.info,
        bluetoothctl.devices(Filters.Connected),
    ):
        percentage = re.search(
            r"(?<=\()\d+(?=\))",
            device.get("battery percentage", ""),
        )
        if percentage:
            device["percentage"] = percentage.group()
            device["battery"] = icons[int(device["percentage"]) // len(icons)]
        try:
            return connected.format(**device)
        except KeyError:
            return ""
    else:
        return online.format(**info)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-n",
        "--online",
        default="",
        help='Format of output when online. Default: ""',
    )
    parser.add_argument(
        "-f",
        "--offline",
        default="󰂲",
        help='Format of output when offline. Default: "󰂲"',
    )
    parser.add_argument(
        "-c",
        "--connected",
        default="{name}",
        help='Format of output for connected devices. Default: "{name}"',
    )
    parser.add_argument(
        "-i",
        "--icons",
        default="󰥇󰤾󰤿󰥀󰥁󰥂󰥃󰥄󰥅󰥆󰥈",
        help='Format of output. Default: "󰥇󰤾󰤿󰥀󰥁󰥂󰥃󰥄󰥅󰥆󰥈"',
    )
    opts = parser.parse_args()
    print(main(**vars(opts)))
