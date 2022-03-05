#!/bin/bash
# originally by Kris Occhipinti
# https://www.youtube.com/watch?v=FsQuGplQvrw

mpv.exe --ytdl-format=bestvideo+bestaudio/best --fs "$(powershell.exe -c "Get-Clipboard")"
