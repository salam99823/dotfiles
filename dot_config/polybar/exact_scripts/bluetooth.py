import re
import shutil
import subprocess
import sys

if shutil.which("bluetoothctl") is None:
    print("bluetoothctl missing", file=sys.stderr)
    exit(-1)


class BTdevice:
    def __init__(self, info: re.Match[str]):
        self.name = info.group("name")
        self.mac = info.group("mac")
        extra_info = bluetoothctl("info", self.mac)
        self.connected = extra_info.find("\n\tConnected: yes\n") != -1
        if not self.connected:
            return
        percentage = re.search(
            r"\tBattery Percentage: 0x(?P<percentage>[0-9a-fA-F]{2}).*$",
            extra_info,
        )
        if percentage is None:
            return
        self.percentage = int(percentage.group("percentage"), 16)


def bluetoothctl(*args) -> str:
    return subprocess.check_output(["bluetoothctl", *args]).decode()


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

    bt_devices = filter(
        lambda device: device.connected,
        (
            BTdevice(info)
            for info in (
                re.search(
                    r"Device (?P<mac>(?::?[0-9A-F]{2})+) (?P<name>.+)",
                    line,
                )
                for line in bluetoothctl("devices", "Trusted").split("\n")
                if line
            )
            if info
        ),
    )
    icons = "󰥇󰤾󰤿󰥀󰥁󰥂󰥃󰥄󰥅󰥆󰥈"
    for device in bt_devices:
        return f"{icons[device.percentage // 10]}", f"{device.percentage}%"
    else:
        return ""


if __name__ == "__main__":
    print(" ".join(main()))
