# user-shell-switcher.fish - Fish shell integration

# Configuration
set -g USER_SHELL_SWITCHER_SHELLS zsh bash fish
set -g USER_SHELL_SWITCHER_DEFAULT_SHELL (basename $SHELL)

# Main function to switch between users and shells
function user_shell_switcher
  # Array to store users
  set -l users
  while read -l line
    set -l parts (string split ":" $line)
    set -l username $parts[1]
    set -l user_shell $parts[7]
    if [ -n "$username" ] && string match -q "*sh*" "$user_shell"
      set -a users $username
    end
  end < /etc/passwd
  
  # User selection
  echo "Select a user to switch to:"
  set -l index 1
  for user in $users
    echo "$index) $user"
    set index (math $index + 1)
  end
  
  read -P "Enter number: " choice
  if [ "$choice" -gt 0 ] && [ "$choice" -le (count $users) ]
    set selected_user $users[(math $choice)]
  else
    echo "Invalid selection. Using current user."
    set selected_user $USER
  end
  
  # Shell selection
  echo "Select a shell to use:"
  set -l index 1
  for shell in $USER_SHELL_SWITCHER_SHELLS
    echo "$index) $shell"
    set index (math $index + 1)
  end
  
  read -P "Enter number: " choice
  if [ "$choice" -gt 0 ] && [ "$choice" -le (count $USER_SHELL_SWITCHER_SHELLS) ]
    set selected_shell $USER_SHELL_SWITCHER_SHELLS[(math $choice)]
  else
    echo "Invalid selection. Using default shell."
    set selected_shell $USER_SHELL_SWITCHER_DEFAULT_SHELL
  end
  
  # Check if shell exists
  if not command -v $selected_shell >/dev/null 2>&1
    echo "Error: $selected_shell is not installed. Using $USER_SHELL_SWITCHER_DEFAULT_SHELL instead."
    set selected_shell $USER_SHELL_SWITCHER_DEFAULT_SHELL
  end
  
  # Switch user and shell
  if [ "$selected_user" = "$USER" ]
    echo "Switching to $selected_shell..."
    exec $selected_shell
  else
    echo "Switching to user $selected_user with $selected_shell..."
    sudo -u $selected_user $selected_shell
  end
end

# Create alias for compatibility
alias user-shell-switcher='user_shell_switcher'

# Add autocompletion
complete -c user_shell_switcher -x

# To use this file:
# In ~/.config/fish/config.fish, add:
# source /path/to/user-shell-switcher.fish