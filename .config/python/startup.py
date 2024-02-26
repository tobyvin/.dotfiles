# Store interactive Python shell history in ~/.cache/python/history
# instead of ~/.python_history.
#
# Create the following .config/python/startup.py file
# and export its path using PYTHONSTARTUP environment variable:
#
# export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

import atexit
import os
import readline

xdg_state = os.getenv("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))
histfile = os.getenv("PYTHONHISTFILE", os.path.join(
    xdg_state, "python", "history"))

alt_histfile = os.path.expanduser("~/.python_history")

if not os.path.exists(histfile) and os.path.exists(alt_histfile):
    histfile = alt_histfile

histfile = os.path.abspath(histfile)
cache_directory, _ = os.path.split(histfile)

os.makedirs(cache_directory, exist_ok=True)

try:
    readline.read_history_file(histfile)
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
