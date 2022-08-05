autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%b'

# Configure color prompt
autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@ %{$fg[yellow]%}%~ %{$reset_color%}% ${vcs_info_msg_0_}%# "
