#!/usr/bin/env python3
import json
import logging
import os
import sys

import dbus

level = logging.DEBUG if os.environ.get("DEBUG") == "true" else logging.INFO

logging.basicConfig(stream=sys.stderr, level=level)

bus = dbus.SessionBus()
valent_object = bus.get_object("ca.andyholmes.Valent", "/ca/andyholmes/Valent")
valent_interface = dbus.Interface(
    valent_object,
    "org.freedesktop.DBus.ObjectManager",
)
managed_objects = valent_interface.GetManagedObjects()

dangerously_empty = False
connected = False
no_connectivity = False

devices = []

for path in managed_objects:
    device_obj = bus.get_object("ca.andyholmes.Valent", path)
    device_action_interface = dbus.Interface(device_obj, "org.gtk.Actions")
    battery_state = device_action_interface.Describe("battery.state")[2][0]
    connectivity_state = device_action_interface.Describe(
        "connectivity_report.state",
    )[2][0]["signal-strengths"]["1"]

    device = {
        "state": (
            "connected"
            if managed_objects[path]
            .get(
                "ca.andyholmes.Valent.Device",
                {},
            )
            .get("State", 0)
            == 3
            else "disconnected"
        ),
        "id": (
            managed_objects[path]
            .get(
                "ca.andyholmes.Valent.Device",
                {},
            )
            .get("Id", 0)
        ),
        "name": (
            managed_objects[path]
            .get(
                "ca.andyholmes.Valent.Device",
                {},
            )
            .get("Name", 0)
        ),
        "battery_percentage": battery_state["percentage"],
        "battery_status": (
            "discharging" if not battery_state["charging"] else "charging"
        ),
        "connectivity_strength": connectivity_state["signal-strength"],
    }

    if device["state"] == "connected":
        connected = True

    if device["connectivity_strength"] <= 1:
        no_connectivity = True

    if device["battery_percentage"] <= 15 and (
        device["battery_status"] == "discharging"
    ):
        dangerously_empty = True

    devices.append(device)

data = {
    "alt": (
        "no-devices"
        if len(devices) == 0
        else "dangerously-empty"
        if dangerously_empty
        else "no-signal"
        if no_connectivity
        else "connected"
        if connected
        else "disconnected"
    ),
    "tooltip": "",
}
data["class"] = data["alt"]

logging.debug(devices)

tooltip = []

CONNECTIVITY_STRENGTH_SYMBOL = ["󰞃", "󰢼", "󰢽", "󰢾", "󰢾"]
BATTERY_PERCENTAGE_SYMBOL = ["󱃍", "󰁺", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

for device in devices:
    battery_symbol = device["battery_percentage"] // 10
    details = (
        f"""\t\
        {CONNECTIVITY_STRENGTH_SYMBOL[device['connectivity_strength']]} \
        {BATTERY_PERCENTAGE_SYMBOL[battery_symbol]} \
        {device['battery_percentage']}% \
        ({device['battery_status']})"""
        if device["state"] == "connected"
        else ""
    )
    tooltip.append(f"{device['name']} ({device['state']}){details}")

data["tooltip"] = "\n".join(tooltip)

print(json.dumps(data))
