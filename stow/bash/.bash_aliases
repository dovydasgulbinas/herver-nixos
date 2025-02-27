# Navigation
alias 2df="cd $HOME/.dotfiles"
alias 2dl="cd $HOME/Downloads"
alias 2de="cd $HOME/Desktop"
alias 2pj="cd $HOME/Documents/Projects"
alias 2dc="cd $HOME/Documents"
alias 2w="cd $HOME/Work"
alias paste='xclip -selection clipboard -o'

alias c="clear"

# Shell Meta
case "$SHELL" in
*bash)
    alias sb="source ~/.bashrc"
    ;;
*zsh)
    alias sb='source ~/.zprofile'
    ;;
*)
    echo "Shell detected UNKNOWN=$SHELL"
    ;;
esac

alias eba="vim ~/.bash_aliases && sb"
alias ebd="vim ~/.bash_dev && sb"
alias ebw='vim ~/.bash_work && sb'
alias ebs='vim ~/.env_secrets && sb'
alias edf="cd $HOME/.dotfiles && nvim ."


# KDE Plasma
alias kde-rr='killall plasmashell && kstart plasmashell'

# Vim
alias vim='nvim'
alias vi='nvim'
alias v="nvim ."
alias txm="tmux a -t main"

# Misc
alias pass="keepassxc-cli"
alias f='grep -rn -e'
alias ff="find . -name"
alias ffd="find . -type d -name"
alias ll="ls -alth"
alias rmr='rm -rf'
alias tre='tree -hpug'

function del {
    mkdir -p ~/.Trash
    local F
    for F; do
        mv -- "$F" ~/.Trash/"$F-$(exec date '+%F-%T')"
    done
}


alias abspath='function _abspath() { echo "$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")"; }; _abspath'
alias gh-pr='gh pr view --web'
PATH="$PATH:$PATH/.local/bin"


