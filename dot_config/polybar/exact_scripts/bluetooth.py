import re
import shutil
import subprocess
import sys

if shutil.which("bluetoothctl") is None:
    print("bluetoothctl missing", file=sys.stderr)
    exit(-1)


class BTdevice:
    def __init__(self, name: str, mac: str):
        self.name, self.mac = name, mac
        percentage = re.search(
            r"\tBattery Percentage: 0x(?P<percentage>[0-9a-fA-F]{2}).*$",
            bluetoothctl("info", self.mac),
        )
        if percentage is None:
            self.percentage = None
            return
        self.percentage = int(percentage.group("percentage"), 16)


def bluetoothctl(*args) -> str:
    return subprocess.check_output(("bluetoothctl", *args)).decode()


def main():
    controller = re.search(
        r"Controller (?P<mac>(?::?[0-9A-F]{2})+) (?P<name>.+)\s+\[default\]",
        bluetoothctl("list"),
    )
    if controller is None or re.search(
        r"\tPower(ed: no|State: off)",
        bluetoothctl("show", controller.group("mac")),
    ):
        return "󰂲"

    bt_devices = (
        BTdevice(info.group("name"), info.group("mac"))
        for info in (
            re.search(
                r"Device (?P<mac>(?::?[0-9A-F]{2})+) (?P<name>.+)",
                line,
            )
            for line in bluetoothctl("devices", "Connected").split("\n")
            if line
        )
        if info
    )
    icons = "󰥇󰤾󰤿󰥀󰥁󰥂󰥃󰥄󰥅󰥆󰥈"
    for device in bt_devices:
        if device.percentage is None:
            return device.name
        return f"{device.name} {icons[device.percentage // 10]} {device.percentage}%"
    else:
        return ""


if __name__ == "__main__":
    print(main())
