export FZF_DEFAULT_COMMAND="fd -t f -L -H -E '.git'"
export FZF_DEFAULT_OPTS="\
--color=bg+:#2d3f76 \
--color=border:#589ed7 \
--color=fg:#c8d3f5 \
--color=gutter:#1e2030 \
--color=header:#ff966c \
--color=hl+:#65bcff \
--color=hl:#65bcff \
--color=info:#545c7e \
--color=marker:#ff007c \
--color=pointer:#ff007c \
--color=prompt:#65bcff \
--color=query:#c8d3f5:regular \
--color=scrollbar:#589ed7 \
--color=separator:#ff966c \
--color=spinner:#ff007c \
--highlight-line \
--layout='reverse' \
--prompt='' \
--marker='󰃀' \
--pointer='' \
--separator='󱋰' \
--info='right' \
--preview='~/.local/bin/fzf-preview {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="\
  $FZF_DEFAULT_OPTS \
  --border='bottom'"
export FZF_CTRL_R_COMMAND=
export FZF_CTRL_R_OPTS="\
  $FZF_DEFAULT_OPTS \
  --preview='' \
  --border='bottom'"
export FZF_ALT_C_COMMAND="fd -t d -L -H -E '.git'"
export FZF_ALT_C_OPTS="\
  $FZF_DEFAULT_OPTS \
  --border='bottom'"
