#!/bin/gawk -f

BEGIN {
	FS = "="
	file = FILENAME
	section = ""
	idx = 0
	sections[0] = "Name"
	entries["Name"] = ""
}

/^\[Desktop Entry]$/ {
	end_file()
}

/^\[Desktop Action .*\]$/ {
	section = substr($0, 17, (length($0) - 17))
}

($1 == "Name" || $1 == "GenericName") {
	sections[idx] = section ? section : $1
	entries[sections[idx]] = $2
	idx++
}

($1 == "Hidden" || $1 == "NoDisplay") && $2 == "true" {
	nextfile
}

$1 == "OnlyShowIn" && $2 != xdg_current_desktop {
	nextfile
}

$1 == "NotShowIn" && $2 == xdg_current_desktop {
	nextfile
}

END {
	end_file()
}

function end_file()
{
	if (entries["Name"]) {
		for (i in sections) {
			section = sections[i]
			if (section == "Name" || section == "GenericName") {
				printf "%s\t%s\n", file, entries[section]
			} else {
				printf "%s#%s\t%s - %s\n", file, section, entries["Name"], entries[section]
			}
		}
	}
	file = FILENAME
	section = ""
	idx = 0
	delete sections
	delete entries
}
