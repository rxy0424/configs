#!/bin/bash

# Current directory
CURRENT_DIR=$(pwd)

# Default target directories
CONFIG_DIR="$HOME/.config"
DOOM_DIR="$HOME/.doom.d"
RIME_DIR="$HOME/.local/share/fcitx5/rime"
HOME_DIR="$HOME"

# Directories to be linked and their target directories
declare -A DIRS=(
    ["i3"]="$CONFIG_DIR/i3"
    ["polybar"]="$CONFIG_DIR/polybar"
    ["rofi"]="$CONFIG_DIR/rofi"
    ["doom_emacs"]="$DOOM_DIR"
    ["rime"]="$RIME_DIR"
)

# Files to be linked to the HOME directory
declare -A FILES=(
    [".Xresources"]="$HOME_DIR/.Xresources"
    [".bashrc"]="$HOME_DIR/.bashrc"
    [".tmux.conf"]="$HOME_DIR/.tmux.conf"
    [".xprofile"]="$HOME_DIR/.xprofile"
)

# Function to create symlinks
create_symlinks() {
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

# Prompt user to select directories and files to link
echo "Please select the directories and files to create symlinks for (enter corresponding numbers, separated by spaces):"
i=1
for dir in "${!DIRS[@]}"; do
    echo "$i) $dir"
    ((i++))
done
for file in "${!FILES[@]}"; do
    echo "$i) $file"
    ((i++))
done
read -p "Selection: " choices

# Prompt user to modify target directories
echo "Do you want to modify the target directories? (y/n)"
read -p "Choice: " modify_dest

if [ "$modify_dest" == "y" ]; then
    for dir in "${!DIRS[@]}"; do
        read -p "Enter the target directory for $dir (current: ${DIRS[$dir]}): " new_dest
        if [ ! -z "$new_dest" ]; then
            DIRS[$dir]=$new_dest
        fi
    done
    for file in "${!FILES[@]}"; do
        read -p "Enter the target directory for $file (current: ${FILES[$file]}): " new_dest
        if [ ! -z "$new_dest" ]; then
            FILES[$file]=$new_dest
        fi
    done
fi

# Convert user selections to directory and file names
selected_dirs=()
selected_files=()
for choice in $choices; do
    case $choice in
        1)
            selected_dirs+=("i3")
            ;;
        2)
            selected_dirs+=("polybar")
            ;;
        3)
            selected_dirs+=("rofi")
            ;;
        4)
            selected_dirs+=("doom_emacs")
            ;;
        5)
            selected_dirs+=("rime")
            ;;
        6)
            selected_files+=(".Xresources")
            ;;
        7)
            selected_files+=(".bashrc")
            ;;
        8)
            selected_files+=(".tmux.conf")
            ;;
        9)
            selected_files+=(".xprofile")
            ;;
        *)
            echo "Invalid selection: $choice"
            ;;
    esac
done

# Create symlinks for the selected directories
for dir in "${selected_dirs[@]}"; do
    src_dir="$CURRENT_DIR/$dir"
    dest_dir="${DIRS[$dir]}"

    if [ -d "$src_dir" ]; then
        create_symlinks "$src_dir" "$dest_dir"
        echo "Created symlinks for $dir in $dest_dir"
    else
        echo "Directory $src_dir does not exist, skipping..."
    fi
done

# Create symlinks for the selected files
for file in "${selected_files[@]}"; do
    if [ -f "$CURRENT_DIR/$file" ]; then
        ln -sf "$CURRENT_DIR/$file" "${FILES[$file]}"
        echo "Created symlink for $file in ${FILES[$file]}"
    else
        echo "File $CURRENT_DIR/$file does not exist, skipping..."
    fi
done

echo "Symlink creation complete."
