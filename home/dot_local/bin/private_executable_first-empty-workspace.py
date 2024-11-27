#!/usr/bin/python3
import argparse
import sys

import i3ipc

# Assumption: it exists 10 workspaces (otherwise, change this value)
NUM_WORKSPACES = 10


def main(arguments: argparse.Namespace):
    ipc = i3ipc.Connection()
    tree = ipc.get_tree()
    workspaces = tree.workspaces()
    focused = tree.find_focused()
    if focused is None:
        return

    current_workspace = focused.workspace()
    if current_workspace is None:
        return

    empty_workspace_numbers = set(
        number for number in range(1, NUM_WORKSPACES + 1)
    ) - set(workspace.num for workspace in workspaces)
    # Take into consideration that
    # the current workspace exists but might be empty
    if len(current_workspace.nodes) == 0:
        empty_workspace_numbers.add(current_workspace.num)

    # Get the minor empty workspace's number
    # (or set it as the current workspace's number if all are busy)
    first_empty_workspace = current_workspace.num
    if empty_workspace_numbers:
        first_empty_workspace = min(empty_workspace_numbers)

    command = ""
    if arguments.move:
        command += "move container to workspace number {}, "
    if arguments.switch:
        command += "workspace number {}"

    replies = ipc.command(
        command.format(
            first_empty_workspace,
            first_empty_workspace,
        )
    )
    for reply in replies:
        if not reply.success:
            print(reply.error, file=sys.stderr)
            break


if __name__ == "__main__":
    arguments_parser = argparse.ArgumentParser()
    arguments_parser.add_argument(
        "-s",
        "--switch",
        action="store_true",
        help="switch to the first empty workspace",
    )
    arguments_parser.add_argument(
        "-m",
        "--move",
        action="store_true",
        help="""
move the currently focused container
to the first empty workspace
""",
    )
    arguments = arguments_parser.parse_args()
    assert (
        arguments.switch or arguments.move
    )  # at least one of the flags must be specificated
    main(arguments)
