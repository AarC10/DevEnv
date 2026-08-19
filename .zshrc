# ---------- Fortune + cowsay (must run before instant prompt captures output) ----------
if [[ -o interactive ]] && command -v fortune >/dev/null && command -v cowsay >/dev/null; then
  fortune | cowsay
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# ---------- Powerlevel10k instant prompt ----------
# Anything that might prompt for input must go ABOVE this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Only run the rest for interactive shells
[[ -o interactive ]] || return

# ---------- Fast PATH setup ----------
typeset -U path PATH

path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/.local/go/bin
  $HOME/go/bin

  $path
)
export PATH

# ---------- Core env ----------
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export EDITOR="nvim"
alias vim="nvim"

# ---------- Secrets (DO NOT commit; chmod 600) ----------
if [[ -r "$HOME/.config/secrets/env.zsh" ]]; then
  source "$HOME/.config/secrets/env.zsh"
fi

# ---------- Oh My Zsh ----------
plugins=(git gitignore sudo fzf)
source "$ZSH/oh-my-zsh.sh"

# ---------- Powerlevel10k ----------
# Do NOT disable instant prompt; fix any startup output instead.
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"

# ---------- Lazy-loaded NVM (removes common startup lag) ----------
export NVM_DIR="$HOME/.nvm"
__load_nvm() {
  unset -f nvm node npm npx pnpm __load_nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}
nvm()  { __load_nvm; nvm  "$@"; }
node() { __load_nvm; node "$@"; }
npm()  { __load_nvm; npm  "$@"; }
npx()  { __load_nvm; npx  "$@"; }

# ---------- Project envs (opt-in; avoids startup delay) ----------
# Call these when you need them, or wire up an autoload_project_env
# function keyed on $PWD once project-specific env vars exist.

# ---------- zoxide (smarter cd) ----------
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

# ---------- Aliases last (must be silent for p10k instant prompt) ----------
[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ---------- Profiling ----------
# Uncomment to measure startup cost; start a new shell and read output; then re-comment.
# zmodload zsh/zprof
# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
