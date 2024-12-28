#!/usr/bin/env python
"""Script for the Waybar weather module."""

import configparser
import locale
import sys
from os import environ, path

import requests

ARGS = "temperature_unit={temperature_unit}&wind_speed_unit={wind_speed_unit}"
URL = f"https://manjaro-sway.download/weather/{{city}}?{ARGS}"
CONFIG_PATH = path.join(
    environ.get("APPDATA")
    or environ.get("XDG_CONFIG_HOME")
    or path.join(environ["HOME"], ".config"),
    "weather.cfg",
)


def parse_config(path):
    config = configparser.ConfigParser()
    config.read(path)

    temperature = config.get("DEFAULT", "temperature", fallback="C")
    distance = config.get("DEFAULT", "distance", fallback="km")

    locale.setlocale(locale.LC_ALL, "")
    current_locale, _ = locale.getlocale(locale.LC_NUMERIC)

    return {
        "city": config.get("DEFAULT", "city", fallback="auto"),
        "temperature_unit": "fahrenheit" if temperature == "F" else "celsius",
        "wind_speed_unit": "mph" if distance == "miles" else "kmh",
        "locale": config.get(
            "DEFAULT",
            "locale",
            fallback=locale.getlocale()[0] or current_locale,
        ),
    }


def main():
    config = parse_config(CONFIG_PATH)
    locale = config["locale"]

    headers = {
        "Accept-Language": f"{locale.replace("_", "-")},{locale.split("_")[0]};q=0.5",
    }
    print(headers)
    return requests.get(
        URL.format(**config),
        timeout=10,
        headers=headers,
    )


if __name__ == "__main__":
    try:
        print(main())
    except Exception as err:
        print(str(err))
        sys.exit(1)
