#!/bin/gawk -f

BEGIN {
	FS = "="
	file = ""
	section = ""
	type = ""
	terminal = 0
	name = ""
	icon = ""
	exec = ""
}

/^\[Desktop Entry]$/ {
	print_entry()
	file = FILENAME
	section = "entry"
	parent = ""
	type = ""
	name = ""
	generic = ""
	icon = ""
	exec = ""
	path = ""
	terminal = 0
	sections["entry"] = 1
}

/^\[Desktop Action .*\]$/ {
	if (type != "Application") {
		nextfile
	}
	print_entry()
	section = substr($0, 17, (length($0) - 17))
	parent = parent ? parent : name
	name = ""
	exec = ""
	icon = ""
	file = sprintf("%s#%s", FILENAME, section)
}

! sections[section] {
	next
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

$1 == "Type" {
	type = $2
	next
}

$1 == "Name" {
	sub("^Name\\s*=\\s*", "", $0)
	name = $0
	next
}

$1 == "GenericName" {
	sub("^GenericName\\s*=\\s*", "", $0)
	generic = $0
	next
}

$1 == "Icon" {
	sub("^Icon\\s*=\\s*", "--icon ", $0)
	icon = $0
	next
}

$1 == "Exec" {
	sub("^Exec\\s*=\\s*", "", $0)
	exec = $0
	next
}

$1 == "Path" {
	sub("^Path\\s*=\\s*", "", $0)
	path = $0
	next
}

$1 == "Terminal" && $2 ~ "true" {
	terminal = 1
	next
}

$1 == "Actions" {
	sub("^Actions\\s*=\\s*", "", $0)
	split($0, arr, ";")
	for (i in arr) {
		sections[arr[i]] = 1
	}
	next
}

END {
	print_entry()
}

function print_entry()
{
	if (type != "Application" || name == "" || exec == "") {
		return
	}
	if (terminal) {
		exec = term " " exec
	}
	gsub("%i", icon, exec)
	gsub("%c", name, exec)
	gsub("%k", FILENAME, exec)
	gsub("%[fFuUdDnNvm]", "", exec)
	if (parent) {
		name = sprintf("%s - %s", parent, name)
	}
	printf "%s\t%s\t%s\n", file, name, exec
}
