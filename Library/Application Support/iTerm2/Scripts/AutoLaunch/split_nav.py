#!/usr/bin/env python3
import iterm2

Keycode = iterm2.Keycode
Modifier = iterm2.Modifier
NavigationDirection = iterm2.NavigationDirection


async def main(connection):
    hjkl_keycodes = [
        Keycode.ANSI_H,
        Keycode.ANSI_J,
        Keycode.ANSI_K,
        Keycode.ANSI_L,
    ]

    app = await iterm2.async_get_app(connection)

    async with iterm2.KeystrokeMonitor(connection) as keystroke_monitor:
        while True:
            keystroke = await keystroke_monitor.async_get()
            keycode = keystroke.keycode
            modifiers = keystroke.modifiers

            current_tab = app.current_window.current_tab
            current_session = current_tab.current_session

            if modifiers == [Modifier.CONTROL] and keycode in hjkl_keycodes:
                focused_nvim_time = await current_session.async_get_variable(
                    "user.FOCUSED_NVIM_TIME"
                )

                if focused_nvim_time is None:
                    match keycode:
                        case Keycode.ANSI_H:
                            await current_tab.async_select_pane_in_direction(
                                NavigationDirection.LEFT
                            )
                        case Keycode.ANSI_J:
                            await current_tab.async_select_pane_in_direction(
                                NavigationDirection.BELOW
                            )
                        case Keycode.ANSI_K:
                            await current_tab.async_select_pane_in_direction(
                                NavigationDirection.ABOVE
                            )
                        case Keycode.ANSI_L:
                            await current_tab.async_select_pane_in_direction(
                                NavigationDirection.RIGHT
                            )
            elif (
                modifiers == [Modifier.OPTION, Modifier.SHIFT]
                and keycode == Keycode.ANSI_X
            ):
                await current_session.async_close()


iterm2.run_forever(main)
