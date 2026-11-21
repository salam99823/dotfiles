#!/usr/bin/env python3

import glob
import os
import sys
from math import ceil, floor


def render_hearts(pct, max_hearts, discharging):
    hearts = max_hearts * pct
    partial = hearts - floor(hearts)

    full_hearts = floor(hearts) + round(partial)
    half_hearts = 1 - round(partial) if hearts != max_hearts else 0
    empty_hearts = max_hearts - ceil(hearts)

    chars = [
        *"󰋑" * full_hearts,
        *"󰛞" * half_hearts,
        *"󰋕" * empty_hearts,
    ]

    if chars[-1] == "󰋕":
        chars[-1] = "󱐲" if discharging else "󱐱"
    elif chars[-1] == "󰋑":
        chars[-1] = "󱐯" if discharging else "󱐮"
    elif chars[0] == "󰋑":
        chars[0] = "󱐯" if discharging else "󱐮"
    else:
        raise ValueError("Invalid state")

    return (
        (f"{floor(pct * 100)}% " if pct <= 1 / max_hearts else "")
        + " ".join(chars)
        + " "
    )


def get_battery_info():
    batteries = sorted(glob.glob("/sys/class/power_supply/BAT*"))
    if not batteries:
        return 1.0, False

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
        return 1.0, False

    avg_pct = (sum(capacities) / len(capacities)) / 100
    discharging = "discharging" in statuses

    return avg_pct, discharging


def main():
    max_hearts = 4
    if "--test" in sys.argv:
        for i in range(1, 101, 1):
            print(f"{i}%\t{render_hearts(i / 100, max_hearts, i % 2 == 0)}")
        return

    pct, discharging = get_battery_info()
    print(render_hearts(pct, max_hearts, discharging))


if __name__ == "__main__":
    main()
