# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# Set prompt
# Exit status indicator in red (if not 0)
# Background job count in yellow (if not 0)
# Date in white, host in magenta, directory in default, prompt character
# Example:
#     1J 23:06:26 ig:~ >
PS1=$'%(?..%B%K{red}[%?]%K{def}%b )%(1j.%b%K{yel}%F{bla}%jJ%F{def}%K{def} .)%F{white}%B%*%b %F{mag}%m:%F{white}%~ %(!.#.>) %F{def}'
#     <------- exit status -------><------- background job count ----------><--- time ---->-< host ->-< cur dir >-<------> <----->
# (See 'EXPANSION OF PROMPT SEQUENCES' in zshmisc.)

# Completion system
autoload -Uz compinit
compinit

# Set less options
if [[ -x $(which less 2> /dev/null) ]]; then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
    export LESSHISTFILE='-'
    if [[ -x $(which lesspipe 2> /dev/null) ]]; then
	LESSOPEN="| lesspipe %s"
	export LESSOPEN
    fi
fi

# Set default editor
if [[ -x $(which emacs 2> /dev/null) ]]; then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# Zsh settings for history
HISTORY_IGNORE="(ls|[bf]g|exit|reset|clear|cd|cd ..|cd..)"
HISTSIZE=25000
HISTFILE=~/.zsh_history
SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# nf [-NUM] [COMMENTARY...] -- never forget last N commands
nf() {
  local n=-1
  [[ "$1" = -<-> ]] && n=$1 && shift
  fc -lnt ": %Y-%m-%d %H:%M ${*/\%/%%} ;" $n | tee -a .neverforget
}

# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Watch other user login/out
watch=notme
export LOGCHECK=60

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors 2> /dev/null` ]]; then
	eval `dircolors -b`
	alias 'ls=ls --color=auto'
    fi
fi

# Commas in ls, du, df output
export BLOCK_SIZE="'1"

# Short command aliases
alias 'l=ls'
alias 'la=ls -A'
alias 'll=ls -l'
alias 'j=jobs -l'
alias 'tf=tail -F'
alias 'grep=grep --colour'
alias "tree=tree -I 'CVS|.git|*~'"
alias 'synchist=fc -RI'

# Typing errors...
alias 'cd..= cd ..'

# MySQL prompt
export MYSQL_PS1="\R:\m:\s \h.\d> "

# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 0
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"
# End of lines added by compinstall

# Username completion.
# Delete old definitions
zstyle -d users
# For everything else, use non-system users from /etc/passwd, plus root
zstyle ':completion:*:*:*:*' users root $(awk -F: '$3 > 1000 && $3 < 65000 { print $1 }' /etc/passwd)

# URL completion. Use URLs from history.
zstyle -e ':completion:*:*:urls' urls 'reply=( ${${(f)"$(egrep --only-matching \(ftp\|https\?\)://\[A-Za-z0-9\].\* $HISTFILE)"}%%[# ]*} )'

# File/directory completion, for cd command
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found' '(*/)#CVS'
#  and for all commands taking file arguments
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'

# Prevent offering a file (process, etc) that's already in the command line.
zstyle ':completion:*:(rm|cp|kill|diff|scp):*' ignore-line yes
# (Use Alt-Comma to do something like "mv abcd.efg abcd.efg.old")

# Completion selection by menu for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Filename suffixes to ignore during completion (except after rm command)
# This doesn't seem to work
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro' '*~'
zstyle ':completion:*:(^rm):*' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro' '*~'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
# Although this does work
zstyle ':completion:*:emacs:*' ignored-patterns '*.asis' '*~'
zstyle '*' single-ignored show

# Finenames to prefer/limit during completion
zstyle ':completion:*:*:loffice:*' file-patterns '*.(doc|docx|dot|dotx|xls|xlsx|xlt|xltx|odt|ods|csv|tsv|txt):documents *(-/):directories' '%p:all-files'

zstyle ':completion:*:*:rmdir:*' file-sort time

# CD to never select parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## Use cache
# Some functions, like _apt and _dpkg, are very slow. You can use a cache in
# order to proxy the list of results (like the list of available debian
# packages)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Move up directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
