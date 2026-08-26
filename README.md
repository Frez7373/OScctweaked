# OScctweaked

A Windows-inspired graphical operating system for CC:Tweaked, designed for Minecraft 1.16.5 RP computers.

## Install

Enable the HTTP API in CC:Tweaked and run:

```lua
wget run https://raw.githubusercontent.com/Frez7373/OScctweaked/main/installer.lua
```

The installer deploys the current shell, core UI, window manager and built-in applications, then creates `startup.lua` so the OS starts on boot.

## UX goals

OScctweaked is designed so players do not need to remember terminal commands for normal RP computer use. Programs are opened from the desktop or Start menu, and the shell provides a Windows-like taskbar, application search and touch/mouse navigation.

## Core

- Windows-style desktop and Start menu
- Application search
- Taskbar with running applications
- Multiple application windows
- Focus, minimize, maximize and close
- Dragging windows with mouse input
- Touch-friendly controls and `monitor_touch` handling
- Responsive layout for different terminal sizes
- Minecraft world-day information

## Built-in apps

- File Explorer
- Calculator
- Notepad with on-screen keyboard
- Paint
- Clock
- Calendar
- Settings and themes
- Task Manager / System
- Web quick links
- Mail
- App Center
- Command Center for rare maintenance actions

## Compatibility approach

The shell uses long-standing CC:Tweaked APIs such as `window.create`, terminal redirects, `mouse_click`, `mouse_drag` and `monitor_touch`, avoiding newer window APIs where possible. This is intentional for Minecraft 1.16.5 Forge compatibility.

## Structure

- `os.lua` - desktop and window manager
- `core/ui.lua` - shared drawing toolkit
- `core/apps.lua` - application registry
- `programs/` - built-in applications
- `installer.lua` - one-command installer

The repository also contains older prototype files from earlier iterations. They are not used by the new shell.
