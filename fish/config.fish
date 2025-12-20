# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
set -x LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
set -x LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
set -x LESS_TERMCAP_me \e'[0m'           # end mode
set -x LESS_TERMCAP_se \e'[0m'           # end standout-mode
set -x LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
set -x LESS_TERMCAP_ue \e'[0m'           # end underline
set -x LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# my environment variables
set -gx PATH ~/.local/bin $PATH 
set -gx FZF_DEFAULT_COMMAND 'fd --type file --follow'
set -gx FZF_CTRL_T_COMMAND 'fd --type file --follow'
set -gx FZF_DEFAULT_OPTS '--height 20%'

# my abbreviations
abbr -a l eza
abbr -a ls eza
abbr -a ll 'eza -l'
abbr -a lla 'eza -lAh'
abbr -a yy yay
abbr -a vim nvim

# my syntax highlighting
set -x fish_color_command normal --bold
set -x fish_color_error red
set -x fish_color_param normal
set -x fish_color_search_match --background='007F3B' # arbitrarily chosen green
set -x fish_color_quote bryellow
set -x fish_color_end brcyan
set -x fish_color_operator brcyan

function fish_greeting # TODO
end

set WORKCONFIG ~/.config/fish/functions/work_config.fish
if test -e "$WORKCONFIG"
    source "$WORKCONFIG"
end
