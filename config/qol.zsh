# CLI quality-of-life layer: eza, zoxide, fzf.
# Doesn't replace your shell config - add one line to your own .zshrc:
#   source /path/to/DevEnv/config/qol.zsh

if command -v eza >/dev/null; then
  alias ls="eza -1 --classify --group-directories-first"
  alias ll="eza --long --header --classify --icons --group-directories-first --no-permissions"
  alias lp="eza --long --header --classify --icons --group-directories-first"
  alias la="eza -a --long --header --classify --icons --group-directories-first"
  alias lt="eza --tree --long --header --classify --icons --group-directories-first"
  alias t="eza --tree --header --classify --icons --group-directories-first"
fi

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Ubuntu's apt fzf predates the `fzf --zsh` flag (added in 0.48) - use the
# Debian-packaged integration scripts instead, fall back to --zsh if a newer
# fzf shows up some other way.
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
elif command -v fzf >/dev/null; then
  eval "$(fzf --zsh)" 2>/dev/null || true
fi
