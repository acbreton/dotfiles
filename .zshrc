# Set platform variables
[ $(uname -s) = "Darwin" ] && export MACOS=1 && export UNIX=1
[ $(uname -s) = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1

setopt HIST_IGNORE_ALL_DUPS

# Generate zsh prompt theme
zsh_prompt() {
    # Load VCS info for prompt
    autoload -Uz vcs_info
    precmd() { vcs_info }
    zstyle ':vcs_info:git:*' formats '%F{red}(%b)%f '

    # Prompt opt
    setopt PROMPT_SUBST

    user="${GITHUB_USER:-$USERNAME}"
 
    userpath="%B%F{green}@${user}%f%b"
    dir="%F{yellow}%~%f"
    PS1="${userpath} ${dir} ${vcs_info_msg_0_}$ "
}
zsh_prompt

if [ $CODESPACES ]
then
	if [ $MACOS ] 
	then
	    eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ $LINUX ]
	then
	    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"	
	fi

	eval "$(rbenv init -)"
	export GITHUB_PATH=/workspaces/github
	export LAUNCH_PATH=/workspaces/actions/launch
	export SKYRISE_PATH=/workspaces/actions/actions-dotnet/src
	alias start-actions='/workspaces/github/script/actions/start-actions'
	alias stop-actions='/workspaces/github/script/actions/stop-actions'
	alias skyrise='cd /workspaces/actions/actions-dotnet/src && ./init.sh'
	PATH=$PATH:/workspaces/actions/actions-dotnet/src/script/autopath
fi
