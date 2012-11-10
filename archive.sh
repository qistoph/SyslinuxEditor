#!/bin/bash

function yesno() {
	if [ $# -ge 2 ]; then
		case $2 in
			y|Y) default="y"; opts="Y/n";;
			n|N) default="n"; opts="y/N";;
			*) default=""; opts="y/n";;
		esac
	else
		default=""
		opts="y/n"
	fi

	while [ 1 ]; do
		echo -n "$1 [$opts]: "
		read ans

		[ -z "$ans" ] && ans="$default"

		case "$ans" in
			y|Y) return 0;; # Return non-error
			n|N) return 1;; # Return error
		esac
	done
}

if yesno "Is everything commited and synced to GitHub?"; then
	git archive HEAD > archive.tar
	git log --pretty=oneline -1 | sed 's/^\(\S\+\).*/git_version = "\1"/' > git-version.js
	tar rf archive.tar git-version.js
	gzip -9 archive.tar
else
	echo "Exit"
fi
