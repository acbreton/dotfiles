# Load VCS info
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{green}(%b)%f '

# Prompt Opt
setopt PROMPT_SUBST

# Configure prompt
PS1='%B%S%F{cyan}%n%f%s%b %~ ${vcs_info_msg_0_}$ '
