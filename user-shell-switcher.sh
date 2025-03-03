#!/usr/bin/env bash
# user-shell-switcher - A plugin to switch between users and shells

# Detect shell environment
CURRENT_SHELL="bash"
if [ -n "$ZSH_VERSION" ]; then
  CURRENT_SHELL="zsh"
elif [ -n "$FISH_VERSION" ]; then
  CURRENT_SHELL="fish"
fi

# Configuration
USER_SHELL_SWITCHER_SHELLS=("zsh" "bash" "fish")
USER_SHELL_SWITCHER_DEFAULT_SHELL="$CURRENT_SHELL"

# Main function to switch between users and shells
user_shell_switcher() {
  # Array to store users
  if [ "$CURRENT_SHELL" = "fish" ]; then
    echo "This script should be sourced from user-shell-switcher.fish when using fish shell."
    echo "Please use: source /path/to/user-shell-switcher.fish"
    return 1
  else
    # Bash/Zsh implementation
    local users=()
    local selected_user=""
    local selected_shell=""
    
    # Get all users with valid shells
    while IFS=: read -r username _ _ _ _ shell _; do
      if [ -n "$username" ] && [[ "$shell" == *"sh"* ]]; then
        users+=("$username")
      fi
    done < /etc/passwd
    
    # Display user selection menu
    echo "Select a user to switch to:"
    select selected_user in "${users[@]}"; do
      if [ -n "$selected_user" ]; then
        break
      else
        echo "Invalid selection. Please try again."
      fi
    done
    
    # Display shell selection menu
    echo "Select a shell to use:"
    select selected_shell in "${USER_ZSH_SWITCHER_SHELLS[@]}"; do
      if [ -n "$selected_shell" ]; then
        break
      else
        echo "Invalid selection. Please try again."
      fi
    done
    
    # Check if the selected shell is installed
    if ! command -v "$selected_shell" > /dev/null 2>&1; then
      echo "Error: $selected_shell is not installed. Using $USER_SHELL_SWITCHER_DEFAULT_SHELL instead."
      selected_shell=$USER_SHELL_SWITCHER_DEFAULT_SHELL
    fi
    
    # Switch to the selected user and shell
    if [ "$selected_user" = "$USER" ]; then
      # Just change shell for current user
      echo "Switching to $selected_shell..."
      exec "$selected_shell"
    else
      # Switch to different user with selected shell
      echo "Switching to user $selected_user with $selected_shell..."
      sudo -u "$selected_user" "$selected_shell"
    fi
  fi
}

# Add command completion for zsh
if [ "$CURRENT_SHELL" = "zsh" ]; then
  _user_shell_switcher_completion() {
    local -a users
    
    # Get all users with valid shells
    while IFS=: read -r username _ _ _ _ shell _; do
      if [ -n "$username" ] && [[ "$shell" == *"sh"* ]]; then
        users+=("$username")
      fi
    done < /etc/passwd
    
    _describe 'users' users
  }
  
  compdef _user_shell_switcher_completion user_shell_switcher
  
# Add command completion for bash  
elif [ "$CURRENT_SHELL" = "bash" ] && [ -n "$BASH_VERSION" ]; then
  _user_shell_switcher_completion() {
    local cur prev words cword
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    
    # Get all users with valid shells
    local users=()
    while IFS=: read -r username _ _ _ _ shell _; do
      if [ -n "$username" ] && [[ "$shell" == *"sh"* ]]; then
        users+=("$username")
      fi
    done < /etc/passwd
    
    COMPREPLY=($(compgen -W "${users[*]}" -- "$cur"))
    return 0
  }
  
  complete -F _user_shell_switcher_completion user_shell_switcher

# Add completion for fish
elif [ "$CURRENT_SHELL" = "fish" ]; then
  # Fish completion would be defined separately in a .fish file
  # We can't define it inline in this script
  echo "Fish completion available in separate file" > /dev/null
fi

# Create aliases for backward compatibility
alias user-shell-switcher='user_shell_switcher'

# Export the function (not supported in fish, no-op there)
if [ "$CURRENT_SHELL" != "fish" ]; then
  export -f user_shell_switcher 2>/dev/null || true
fi

# For fish shell, this script should be sourced differently:
# In ~/.config/fish/config.fish, add:
# source /path/to/user-shell-switcher.fish