#!/bin/bash

# Configurable variables
WORKSPACE_DIR=$(pwd)
MODE="auto"
ALL_FILES=false
FILES=()

# Set paths based on mode
function set_paths() {
  if [ "$MODE" == "rules" ]; then
    SOURCE_DIR="$WORKSPACE_DIR/.mixdown/instructions/rules"
    TARGET_DIR="$WORKSPACE_DIR/.cursor/rules"
    SOURCE_EXT=".md"
    TARGET_EXT=".mdc"
  elif [ "$MODE" == "templates" ]; then
    SOURCE_DIR="$WORKSPACE_DIR/.mixdown/templates"
    TARGET_DIR="$WORKSPACE_DIR/.agent/templates"
    SOURCE_EXT=".md"
    TARGET_EXT=".md"
  fi
}

# Function to detect mode based on file path
function detect_mode() {
  local FILE_PATH="$1"
  if [[ "$FILE_PATH" == *".mixdown/templates/"* || "$FILE_PATH" == "templates/"* ]]; then
    echo "templates"
  elif [[ "$FILE_PATH" == *".mixdown/instructions/rules/"* || "$FILE_PATH" == "rules/"* ]]; then
    echo "rules"
  else
    # If can't detect from path, try to find the file in either directory
    if [ -f "$WORKSPACE_DIR/.mixdown/templates/$FILE_PATH" ] || [ -f "$WORKSPACE_DIR/.mixdown/templates/$FILE_PATH.md" ]; then
      echo "templates"
    elif [ -f "$WORKSPACE_DIR/.mixdown/instructions/rules/$FILE_PATH" ] || [ -f "$WORKSPACE_DIR/.mixdown/instructions/rules/$FILE_PATH.md" ]; then
      echo "rules"
    else
      # Default to rules if can't find file anywhere
      echo "rules"
    fi
  fi
}

# Function to create symlinks
function create_symlink() {
  local SOURCE_PATH="$1"
  
  # Extract just the filename without path
  FILENAME=$(basename "$SOURCE_PATH")
  # Remove extension and add target extension
  TARGET_NAME="${FILENAME%.*}$TARGET_EXT"
  
  # Create the target directory if it doesn't exist
  mkdir -p "$TARGET_DIR"
  
  # Create the symlink using absolute paths
  ln -sf "$SOURCE_PATH" "$TARGET_DIR/$TARGET_NAME"
  echo "Created symlink: $TARGET_DIR/$TARGET_NAME -> $SOURCE_PATH"
  
  # Test if symlink works
  if [ -L "$TARGET_DIR/$TARGET_NAME" ] && [ -e "$TARGET_DIR/$TARGET_NAME" ]; then
    echo "✅ Symlink is valid and working"
  else
    echo "❌ Symlink creation failed or link is broken"
    echo "Debugging information:"
    ls -la "$TARGET_DIR/$TARGET_NAME"
    readlink "$TARGET_DIR/$TARGET_NAME"
  fi
}

# Function to find file in source directories
function find_file() {
  local FILENAME="$1"
  local FOUND_PATH=""
  local ORIGINAL_MODE="$MODE"
  
  # If already has a path that contains directory indicators, use as is
  if [[ "$FILENAME" == *"/"* ]]; then
    # Check if file exists directly
    if [ -f "$FILENAME" ]; then
      FOUND_PATH="$FILENAME"
    # Check with extension
    elif [ -f "$FILENAME$SOURCE_EXT" ]; then
      FOUND_PATH="$FILENAME$SOURCE_EXT"
    fi
  else
    # Always check both directories no matter the mode
    # First check templates directory
    if [ -f "$WORKSPACE_DIR/.mixdown/templates/$FILENAME" ]; then
      FOUND_PATH="$WORKSPACE_DIR/.mixdown/templates/$FILENAME"
      if [ "$MODE" == "auto" ]; then
        MODE="templates"
        set_paths
      fi
    elif [ -f "$WORKSPACE_DIR/.mixdown/templates/$FILENAME.md" ]; then
      FOUND_PATH="$WORKSPACE_DIR/.mixdown/templates/$FILENAME.md"
      if [ "$MODE" == "auto" ]; then
        MODE="templates"
        set_paths
      fi
    # Then check rules directory
    elif [ -f "$WORKSPACE_DIR/.mixdown/instructions/rules/$FILENAME" ]; then
      FOUND_PATH="$WORKSPACE_DIR/.mixdown/instructions/rules/$FILENAME"
      if [ "$MODE" == "auto" ]; then
        MODE="rules"
        set_paths
      fi
    elif [ -f "$WORKSPACE_DIR/.mixdown/instructions/rules/$FILENAME.md" ]; then
      FOUND_PATH="$WORKSPACE_DIR/.mixdown/instructions/rules/$FILENAME.md"
      if [ "$MODE" == "auto" ]; then
        MODE="rules"
        set_paths
      fi
    # Finally check current directory and workspace root
    elif [ -f "$WORKSPACE_DIR/$FILENAME" ]; then
      FOUND_PATH="$WORKSPACE_DIR/$FILENAME"
    elif [ -f "$WORKSPACE_DIR/$FILENAME.md" ]; then
      FOUND_PATH="$WORKSPACE_DIR/$FILENAME.md"
    # If still not found but MODE is explicitly set, check current mode's SOURCE_DIR
    elif [ "$MODE" != "auto" ] && [ -f "$SOURCE_DIR/$FILENAME" ]; then
      FOUND_PATH="$SOURCE_DIR/$FILENAME"
    elif [ "$MODE" != "auto" ] && [ -f "$SOURCE_DIR/$FILENAME$SOURCE_EXT" ]; then
      FOUND_PATH="$SOURCE_DIR/$FILENAME$SOURCE_EXT"
    fi
  fi
  
  # If we found a file but MODE is not auto, warn if target location doesn't match mode
  if [ -n "$FOUND_PATH" ] && [ "$MODE" != "auto" ]; then
    # Check if the found path is in the correct directory for the mode
    if [[ "$MODE" == "templates" && ! "$FOUND_PATH" == *".mixdown/templates/"* ]] || 
       [[ "$MODE" == "rules" && ! "$FOUND_PATH" == *".mixdown/instructions/rules/"* ]]; then
      echo "Warning: File found at '$FOUND_PATH' but will be symlinked according to '$MODE' mode"
    fi
  fi
  
  # Return found path or empty string
  echo "$FOUND_PATH"
}

# Function to process a file path
function process_file() {
  local FILE_PATH="$1"
  local CURRENT_MODE="$MODE"
  
  # If mode is auto, detect from file path
  if [ "$CURRENT_MODE" == "auto" ]; then
    CURRENT_MODE=$(detect_mode "$FILE_PATH")
    echo "Detected mode: $CURRENT_MODE for file $FILE_PATH"
    
    # Set paths for the detected mode
    MODE="$CURRENT_MODE"
    set_paths
  fi
  
  # Find the file
  SOURCE_PATH=$(find_file "$FILE_PATH")
  
  if [ -z "$SOURCE_PATH" ]; then
    echo "Error: Could not find file '$FILE_PATH'"
    echo "Searched in:"
    echo "  - $WORKSPACE_DIR/.mixdown/templates/ (with and without .md extension)"
    echo "  - $WORKSPACE_DIR/.mixdown/instructions/rules/ (with and without .md extension)"
    echo "  - Current directory and workspace root"
    return 1
  fi
  
  # Convert to absolute path if it's not already
  if [[ ! "$SOURCE_PATH" = /* ]]; then
    SOURCE_PATH="$WORKSPACE_DIR/$SOURCE_PATH"
  fi
  
  create_symlink "$SOURCE_PATH"
  return 0
}

# Function to show usage
function show_usage() {
  echo "Usage: $0 [OPTIONS] [file_paths...]"
  echo ""
  echo "Options:"
  echo "  --rule, -r [files...]    : Create rule symlinks for specified files"
  echo "  --template, -t [files...]: Create template symlinks for specified files"
  echo "  --all                    : Process all files in the selected mode"
  echo "  -h, --help               : Show this help message"
  echo ""
  echo "If no options are provided, the script will try to detect the appropriate"
  echo "action based on the file path. If no files are specified, it will show this help."
  echo ""
  echo "Examples:"
  echo "  $0 path/to/file.md         # Auto-detect mode based on file path"
  echo "  $0 --rule rule-name        # Symlink a specific rule"
  echo "  $0 --template template1    # Symlink a specific template"
  echo "  $0 --template --all        # Symlink all templates"
  exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --template|-t)
      MODE="templates"
      set_paths
      shift
      # If the next arg is --all, don't treat it as a file
      if [[ "$1" == "--all" ]]; then
        continue
      fi
      # Collect all files until next option
      while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
        FILES+=("$1")
        shift
      done
      ;;
    --rule|-r)
      MODE="rules"
      set_paths
      shift
      # If the next arg is --all, don't treat it as a file
      if [[ "$1" == "--all" ]]; then
        continue
      fi
      # Collect all files until next option
      while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
        FILES+=("$1")
        shift
      done
      ;;
    --all)
      ALL_FILES=true
      shift
      ;;
    -h|--help)
      show_usage
      ;;
    *)
      # If not an option, it's a file path
      FILES+=("$1")
      shift
      ;;
  esac
done

# Initial path setup if not already set
if [ "$MODE" == "auto" ]; then
  # Default to rules for directory operations if no specific mode detected
  if [ ${#FILES[@]} -eq 0 ] || [ "$ALL_FILES" = true ]; then
    MODE="rules"
  fi
  set_paths
fi

# If no files and --all not specified, show usage
if [ ${#FILES[@]} -eq 0 ] && [ "$ALL_FILES" = false ]; then
  show_usage
fi

# Process all files if requested
if [ "$ALL_FILES" = true ]; then
  echo "Processing all $MODE files..."
  for SOURCE_PATH in $SOURCE_DIR/*$SOURCE_EXT; do
    if [ -f "$SOURCE_PATH" ]; then
      create_symlink "$SOURCE_PATH"
    fi
  done
  exit 0
fi

# Process specified files
for FILE in "${FILES[@]}"; do
  process_file "$FILE"
done
