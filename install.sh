#!/bin/bash

# Current directory
CURRENT_DIR=$(pwd)

# Default target directories
CONFIG_DIR="$HOME/.config"
DOOM_DIR="$HOME/.doom.d"
RIME_DIR="$HOME/.local/share/fcitx5/rime"
HOME_DIR="$HOME"

# Directories and files to be linked and their target directories
declare -A ITEMS=(
    ["i3"]="$CONFIG_DIR/i3"
    ["polybar"]="$CONFIG_DIR/polybar"
    ["rofi"]="$CONFIG_DIR/rofi"
    ["doom_emacs"]="$DOOM_DIR"
    ["rime"]="$RIME_DIR"
    [".Xresources"]="$HOME_DIR/.Xresources"
    [".bashrc"]="$HOME_DIR/.bashrc"
    [".tmux.conf"]="$HOME_DIR/.tmux.conf"
    [".xprofile"]="$HOME_DIR/.xprofile"
)

# Function to create symlinks for files in a directory
create_symlinks_in_directory() {
    local src_dir=$1
    local dest_dir=$2

    # Create target directory if it does not exist
    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir"
    fi

    # Create symlinks for files in the source directory
    for file in "$src_dir"/*; do
        ln -sf "$file" "$dest_dir/$(basename "$file")"
    done
}

# Function to create symlinks for a single file
create_symlink_for_file() {
    local src=$1
    local dest=$2

    # Create target directory if it does not exist
    if [ ! -d "$(dirname "$dest")" ]; then
        mkdir -p "$(dirname "$dest")"
    fi

    # Create symlink
    ln -sf "$src" "$dest"
}

# Prompt user to select directories and files to link
echo "Please select the directories and files to create symlinks for (enter corresponding numbers, separated by spaces):"
i=1
ITEM_KEYS=()
for item in "${!ITEMS[@]}"; do
    echo "$i) $item"
    ITEM_KEYS+=("$item")
    ((i++))
done
read -p "Selection: " choices

# Convert user selections to item names
selected_items=()
for choice in $choices; do
    index=$((choice - 1))
    if [ $index -ge 0 ] && [ $index -lt ${#ITEM_KEYS[@]} ]; then
        selected_items+=("${ITEM_KEYS[$index]}")
    else
        echo "Invalid selection: $choice"
    fi
done

# Prompt user to modify target directories for selected items
echo "Do you want to modify the target directories for selected items? (y/n)"
read -p "Choice: " modify_dest

if [ "$modify_dest" == "y" ]; then
    for item in "${selected_items[@]}"; do
        read -p "Enter the target directory for $item (current: ${ITEMS[$item]}): " new_dest
        if [ ! -z "$new_dest" ]; then
            ITEMS[$item]=$new_dest
        fi
    done
fi

# Create symlinks for the selected items
for item in "${selected_items[@]}"; do
    src="$CURRENT_DIR/$item"
    dest="${ITEMS[$item]}"

    if [ -d "$src" ]; then
        create_symlinks_in_directory "$src" "$dest"
        echo "Created symlinks for files in directory $item in $dest"
    elif [ -f "$src" ]; then
        create_symlink_for_file "$src" "$dest"
        echo "Created symlink for file $item in $dest"
    else
        echo "Source $src does not exist, skipping..."
    fi
done

echo "Symlink creation complete."
