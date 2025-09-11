#!/usr/bin/env zsh

# Color codes for echo -e output
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_RED="\033[31m"
COLOR_CYAN="\033[36m"
COLOR_BOLD_RED="\033[1;31m"

# Don't run if already inside tmux
[[ -n "$TMUX" ]] && return

# List existing tmux sessions
sessions=("${(@f)$(tmux list-sessions -F "#{session_name}" 2>/dev/null)}")
session_count=${#sessions}

if (( session_count == 0 )); then
  echo -e "${COLOR_CYAN}No tmux sessions found.${COLOR_RESET}"
  echo -ne "${COLOR_CYAN}Start a new tmux session? (${COLOR_GREEN}y${COLOR_CYAN}/${COLOR_RED}n${COLOR_CYAN}): ${COLOR_RESET}"
  read -k 1 yn
  echo  # Move to next line
  case "$yn" in
    y|Y) exec tmux ;;
    *) return ;;
  esac
else
  echo -e "${COLOR_CYAN}Tmux sessions:${COLOR_RESET}"
  i=1
  for s in $sessions; do
    echo -e "  [${COLOR_GREEN}$i${COLOR_RESET}] ${COLOR_YELLOW}$s${COLOR_RESET}"
    eval "session_$i=\"$s\""
    ((i++))
  done
  echo -e "  [${COLOR_BLUE}n${COLOR_RESET}] ${COLOR_BLUE}New session${COLOR_RESET}"
  echo -e "  [${COLOR_RED}q${COLOR_RESET}] ${COLOR_RED}Quit (normal shell)${COLOR_RESET}"
  echo -ne "${COLOR_CYAN}Attach by number, [${COLOR_BLUE}n${COLOR_CYAN}]ew, or [${COLOR_RED}q${COLOR_CYAN}]uit: ${COLOR_RESET}"
  read -k 1 choice
  echo  # Move to next line

  if [[ "$choice" == "n" ]]; then
    exec tmux
  elif [[ "$choice" == "q" ]]; then
    clear
    return
  elif [[ "$choice" =~ '^[1-9]$' && "$choice" -le $session_count ]]; then
    eval "sess=\$session_$choice"
    exec tmux attach-session -t "$sess"
  else
    echo -e "${COLOR_BOLD_RED}Invalid choice. Starting normal shell.${COLOR_RESET}"
    return
  fi
fi
