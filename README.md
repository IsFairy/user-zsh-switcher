# user-shell-switcher
A simple plugin to switch between users and their shell preferences. Compatible with Zsh, Bash, and Fish shells!

## Installation

1. Clone the repository

```bash
git clone https://github.com/yourusername/user-shell-switcher.git
```

2. Add the appropriate line to your shell configuration file:

**For Zsh users** (in `.zshrc`):
```bash
source /path/to/user-shell-switcher/user-shell-switcher.sh
```

**For Bash users** (in `.bashrc`):
```bash
source /path/to/user-shell-switcher/user-shell-switcher.sh
```

**For Fish users** (in `~/.config/fish/config.fish`):
```fish
source /path/to/user-shell-switcher/user-shell-switcher.fish
```

3. Reload your shell configuration:

**For Zsh/Bash:**
```bash
source ~/.zshrc  # or ~/.bashrc for bash users
```

**For Fish:**
```fish
source ~/.config/fish/config.fish
```

## Usage

Run the command to start the interactive selector:

```
user_shell_switcher
```

Or use the dash-version:
```
user-shell-switcher
```

For backward compatibility, these aliases are also available:
```
user_zsh_switcher
user-zsh-switcher
```

This will:
1. Display a menu to select a user from the system
2. Display a menu to select a shell (zsh, bash, or fish)
3. Switch to the selected user and shell

## Configuration

You can modify the available shells by editing the configuration variables in the script:

**For Zsh/Bash:**
```bash
# Default shells
USER_ZSH_SWITCHER_SHELLS=("zsh" "bash" "fish")

# You can change this to include only shells you have installed
USER_ZSH_SWITCHER_SHELLS=("zsh" "bash")
```

**For Fish:**
```fish
# Configure available shells
set -g USER_ZSH_SWITCHER_SHELLS zsh bash fish
```

## Requirements

- One of: Zsh, Bash, or Fish shell
- Sudo access (for switching users)

## Command Completion

The script includes shell-specific command completion for all supported shells:
- Zsh: Uses `compdef` for tab completion
- Bash: Uses `complete` for tab completion
- Fish: Includes basic completion in the `.fish` file

## Testing

You can test the syntax of the scripts without executing them:

```bash
# Test bash/zsh script
bash -n user-shell-switcher.sh
zsh -n user-shell-switcher.sh

# Test fish script (if fish is installed)
fish --no-execute user-shell-switcher.fish
```

To test the functionality, you can source the script and run it:

```bash
# In bash
source ./user-shell-switcher.sh && user_shell_switcher

# In zsh
source ./user-shell-switcher.sh && user_shell_switcher

# In fish
source ./user-shell-switcher.fish && user_shell_switcher
```

## Troubleshooting

- **Function not found**: Make sure you're using the underscore version (`user_shell_switcher`). The dash version is provided as an alias.
- **Fish shell errors**: If you get errors in Fish shell, make sure you're using the `.fish` file, not the `.sh` file.
- **Permission errors**: When switching users, you may need sudo access.
- **Backward compatibility**: If you previously used `user-zsh-switcher`, all old function names are aliased to the new ones.
