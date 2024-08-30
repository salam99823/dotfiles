#!/bin/env python3
import argparse
import os
import signal
import subprocess
import sys
import tempfile


def main(channels, framerate, bars, colors):
    conf_channels = ""
    if channels != "stereo":
        conf_channels = f"channels=mono\nmono_option={channels}"
    ramps = [
        f"%{{F#{colors[0].strip(" #")}}}{ramp}%{{F-}}"
        for ramp in (" ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█")
    ]
    ramps.extend(f"%{{F#{color.strip(" #")}}}█%{{F-}}" for color in colors[1:])
    ramps = tuple(ramps)
    cava_conf = tempfile.mkstemp(prefix="polybar-cava-conf.")[1]
    with open(cava_conf, "w") as cava_conf_file:
        cava_conf_file.write(
            "[general]\n"
            f"framerate={framerate}\n"
            f"bars={bars}\n"
            "[output]\n"
            "method=raw\n"
            "data_format=ascii\n"
            f"ascii_max_range={len(ramps) - 1}\n"
            "bar_delimiter=32\n" + conf_channels
        )
    cava_proc = subprocess.Popen(
        ("cava", "-p", cava_conf),
        stdout=subprocess.PIPE,
    )
    if cava_proc.stdout is None:
        return
    proc = subprocess.Popen(
        (
            "python3",
            "-c",
            f"""\
{ramps=}
while True:
    print("".join(ramps[bar] for bar in map(int, input().split())))""",
        ),
        stdin=cava_proc.stdout,
    )

    def cleanup(sig, _):
        os.remove(cava_conf)
        cava_proc.send_signal(sig)
        proc.send_signal(sig)
        sys.exit()

    signal.signal(signal.SIGTERM, cleanup)
    signal.signal(signal.SIGINT, cleanup)
    proc.wait()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-f",
        "--framerate",
        type=int,
        default=60,
        help="Framerate to be used by cava, default is 60",
    )
    parser.add_argument(
        "-b",
        "--bars",
        type=int,
        default=16,
        help="Amount of bars, default is 16",
    )
    parser.add_argument(
        "-C",
        "--colors",
        required=True,
        type=lambda arg: arg.split(","),
        default="#82aaff",
        help="Toml config",
    )
    parser.add_argument(
        "-c",
        "--channels",
        choices=("stereo", "left", "right", "average"),
        default="stereo",
        help="Audio channels to be used, defaults to stereo",
    )
    opts = parser.parse_args()
    main(**dict(opts._get_kwargs()))
