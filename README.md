# OScctweaked 😎

A Windows-inspired touchscreen operating system written in Lua for CC:Tweaked.

## Install

Enable HTTP in CC:Tweaked and run:

```lua
wget run https://raw.githubusercontent.com/Frez7373/OScctweaked/main/installer.lua
```

## Current shell

- Windows-style desktop
- Start Menu
- Taskbar
- Touchscreen-first navigation
- Lock screen
- Notification/toast area
- Desktop refresh button
- World-day clock
- Responsive layout for different terminal sizes

## Apps

- File Explorer
- Calculator
- Touch Notepad with on-screen keyboard
- Clock
- Paint
- System Monitor
- Settings
- Calendar
- Touch Terminal
- HTTP Browser
- About

## Architecture

`os.lua` is the desktop shell, `ui.lua` is the shared visual toolkit, and `apps/` contains applications. Built-in applications use `mouse_click` and `monitor_touch` for touchscreen navigation.

## Target

CC:Tweaked computers and advanced computers with monitors/touchscreen peripherals.
