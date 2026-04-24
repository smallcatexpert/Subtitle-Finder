#!/bin/bash

# Set to false to actually delete
DRY_RUN=true

MEDIA_DIR="/mnt/user/data/media/movies"

find "$MEDIA_DIR" -type d | while read dir; do
    # Get the main video file (assumes one per folder)
    video=$(find "$dir" -maxdepth 1 -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) | head -n 1)

    [ -z "$video" ] && continue

    vidbase=$(basename "$video")
    vidname="${vidbase%.*}"

    # Loop through subtitle files in that folder
    find "$dir" -maxdepth 1 -type f \( -iname "*.srt" -o -iname "*.ass" -o -iname "*.sub" \) | while read sub; do
        subbase=$(basename "$sub")

        if [[ "$subbase" != "$vidname"* ]]; then
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY RUN] Would delete: $sub"
            else
                echo "Deleting: $sub"
                rm "$sub"
            fi
        fi
    done
done
