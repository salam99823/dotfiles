function yy () {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function zj() {
  local mode="$1"
  local prompt=" All > "
  case "$mode" in
    p|projects) prompt=" Project > " ;;
    r|refs)     prompt=" Ref > " ;;
    c|config)   prompt=" Config > " ;;
    "")         ;;
    *)
      echo "Usage: zj [p|r|c]"
      return 1
      ;;
  esac

  local active_sessions=""
  if [[ -z "$ZELLIJ" ]]; then
    active_sessions=$(zellij list-sessions --short 2>/dev/null)
  fi

  local choice
  choice=$(
    {
      if [[ -z "$mode" || "$mode" == "p" || "$mode" == "projects" ]]; then
        find "$HOME/Projects" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
      fi
      if [[ -z "$mode" || "$mode" == "r" || "$mode" == "refs" ]]; then
        find "$HOME/Refs" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
      fi
      if [[ -z "$mode" || "$mode" == "c" || "$mode" == "config" ]]; then
        echo "$HOME/.local/share/chezmoi"
        echo "$HOME/.local/bin"
      fi
    } | while IFS= read -r dir; do
      local short_name="${dir:t}"
      local session="${short_name//./_}"
      local tag=""

      if [[ "$dir" == "$HOME/Refs/"* ]]; then
        session="ref_${session}"
        [[ -z "$mode" ]] && tag=" \033[1;34m[ref]\033[0m"
      fi

      if [[ -z "$ZELLIJ" ]] && grep -Fxq "$session" <<< "$active_sessions"; then
        tag="${tag} \033[1;32m[active]\033[0m"
      fi

      printf "%s\t%s%b\n" "$dir" "$short_name" "$tag"
    done | fzf --ansi --delimiter='\t' --with-nth=2 --prompt="$prompt" --height=40% --reverse --border
  )

  [[ -z "$choice" ]] && return

  local selected="${choice%%$'\t'*}"
  local short_name="${selected:t}"
  local session_name="${short_name//./_}"
  [[ "$selected" == "$HOME/Refs/"* ]] && session_name="ref_${session_name}"

  local layout="zjstatus"
  if [[ -f "$selected/Cargo.toml" ]]; then
    layout="rust"
  elif [[ -f "$selected/pom.xml" || -f "$selected/build.gradle" || -f "$selected/build.gradle.kts" ]] || \
       [[ -n "$(find "$selected" -maxdepth 2 -name '*.java' -print -quit 2>/dev/null)" ]]; then
    layout="java"
  fi

  if [[ -n "$ZELLIJ" ]]; then
    zellij action new-tab --cwd "$selected" --layout "$layout" --name "$short_name"
  else
    zellij attach --create "$session_name" options --default-cwd "$selected" --default-layout "$layout"
  fi
}
