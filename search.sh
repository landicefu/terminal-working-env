function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print | grepInFileIgnore "$@"
}

function jgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.java" -print | grepInFileIgnore "$@"
}

function jsgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.js" -print | grepInFileIgnore "$@"
}


function hgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.h" -print | grepInFileIgnore "$@"
}


function resgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.xml" -print | grepInFileIgnore "$@"
}

alias sgrep='smaligrep'
function smaligrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.smali" -print | grepInFileIgnore "$@"
}

function vgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f  -name "*\.v" -print | grepInFileIgnore "$@"
}

function grepInFileIgnore()
{
	ARGS=()
	local ignore_build=0
	for var in "$@"; do
		if [ "$var" == "-ib" ]; then
			ignore_build=1
		else
			ARGS+=("$var")
		fi
	done

	if [ $ignore_build -eq 1 ]; then
		grep -v \/build\/ | xargs grep -n --color "${ARGS[@]}"
	else
		xargs grep -n --color "${ARGS[@]}"
	fi
}