#!/bin/awk -f
BEGIN {
	FS = "="
	stdout = ""
}

/^\[Desktop Entry]$/ {
	if (stdout) {
		print stdout
	}
	stdout = sprintf("%s\t", FILENAME)
	entry = ""
}

/^\[Desktop Action .*\]$/ {
	print stdout
	stdout = sprintf("%s:%s\t%s - ", FILENAME, substr($0, 17, (length($0) - 17)), entry)
}

($1 == "Hidden" || $1 == "NoDisplay") && $2 == "true" {
	stdout = entry = ""
	nextfile
}

$1 == "OnlyShowIn" && $2 != xdg_current_desktop {
	stdout = entry = ""
	nextfile
}

$1 == "NotShowIn" && $2 == xdg_current_desktop {
	stdout = entry = ""
	nextfile
}

$1 == "Name" {
	stdout = stdout $2
	entry = entry ? entry : $2
}

END {
	if (stdout) {
		print stdout
	}
}

