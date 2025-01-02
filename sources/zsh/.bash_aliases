# Navigation
alias gdf="cd ~/dotfiles"
alias gdl="cd ~/Downloads"
alias gde="cd ~/Desktop"
alias gpr="cd ~/Projects"
alias gwo="cd ~/Work"

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
alias edf="cd ~/.dotfiles && nvim ."


# KDE Plasma
alias kde-rr='killall plasmashell && kstart plasmashell'

# Vim
alias vim='nvim'
alias vi='nvim'
alias v="nvim ."

# Misc
alias pass="keepassxc-cli"
alias f='grep -rn -e'
alias ff="find . -name"
alias ffd="find . -type d -name"
alias ll="ls -alth"
alias rmr='rm -rf'
alias tre='tree -hpug'



alias abspath='function _abspath() { echo "$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")"; }; _abspath'
PATH="$PATH:$PATH/.local/bin"
