function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep -n --color "$@"
}

function jgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.java" -print0 | xargs -0 grep -n --color "$@"
}

function jsgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.js" -print0 | xargs -0 grep -n --color "$@"
}


function hgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.h" -print0 | xargs -0 grep -n --color "$@"
}


function resgrep()
{

    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.xml" -print0 | xargs -0 grep -n --color "$@"
}

alias sgrep='smaligrep'
function smaligrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.smali" -print0 | xargs -0 grep -n --color "$@"
}

function vgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f  -name '*\.v' -print0 | xargs -0 grep -n --color "$@"
}
