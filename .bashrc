parse_git_repo() {
    basename -s .git `git config --get remote.origin.url` 2> /dev/null
}
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
get_git_info_colored() {
    red='\033[01;31m'
    yellow='\033[0;93m'
    reset='\033[00m'
    repo=$(parse_git_repo)
    branch=$(parse_git_branch)

    if [ -n "$repo" ] && [ -n "$branch" ]; then
        echo -e "$red($reset$yellow$repo$reset:$red$branch$reset$red)$reset"
    elif [ -n "$repo" ]; then
        echo -e "$red($reset$yellow$repo$reset$red)$reset"
    elif [ -n "$branch" ]; then
        echo -e "$red($reset$red$branch$reset$red)$reset"
    fi
}
get_git_info() {
    repo=$(parse_git_repo)
    branch=$(parse_git_branch)

    if [ -n "$repo" ] && [ -n "$branch" ]; then
        echo "($repo:$branch)"
    elif [ -n "$repo" ]; then
        echo "($repo)"
    elif [ -n "$branch" ]; then
        echo "($branch)"
    fi
}
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(get_git_info_colored)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(get_git_info)\$ '
fi
unset color_prompt force_color_prompt
