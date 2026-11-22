#!/usr/bin/env python3
"""
Zelda-style heart battery indicator for Arch Linux (/sys/class/power_supply).
Based on: https://gist.github.com/zspotter/e4b361a398d8d8818f2cfeab3c25df80/
"""  # noqa: EXE001

import glob
import os
import sys


def render_hearts(pct, max_hearts, discharging):
    half_steps = round(pct / 50 * max_hearts)
    full_hearts = half_steps // 2
    half_hearts = half_steps % 2
    empty_hearts = max_hearts - full_hearts - half_hearts

    chars = [
        *"󰋑" * full_hearts,
        *"󰛞" * half_hearts,
        *"󰋕" * empty_hearts,
    ]

    percent = f"{pct}% " if pct < 10 else ""

    if chars[0] == "󰋑":
        chars[0] = "󱐯" if discharging else "󱐮"
    else:
        chars[0] = "󱐲" if discharging else "󱐱"

    return f"{percent}{' '.join(chars)} "


def get_battery_info():
    batteries = sorted(glob.glob("/sys/class/power_supply/BAT*"))
    if not batteries:
        return 100, False

    capacities = []
    statuses = []

    for bat in batteries:
        cap_file = os.path.join(bat, "capacity")
        stat_file = os.path.join(bat, "status")

        if os.path.exists(cap_file) and os.path.exists(stat_file):
            with open(cap_file, "r", encoding="utf-8") as f:
                capacities.append(int(f.read().strip()))
            with open(stat_file, "r", encoding="utf-8") as f:
                statuses.append(f.read().strip().lower())

    if not capacities:
        return 100, False

    avg_pct = sum(capacities) / len(capacities)
    discharging = "discharging" in statuses

    return avg_pct, discharging


def main():
    max_hearts = 10
    if "--test" in sys.argv:
        for i in range(1, 101):
            print(f"{i}%\t{render_hearts(i, max_hearts, i % 2 == 0)}")
        return

    pct, discharging = get_battery_info()
    print(render_hearts(pct, max_hearts, discharging))


if __name__ == "__main__":
    main()
