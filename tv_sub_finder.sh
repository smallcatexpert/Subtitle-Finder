#!/bin/bash

DRY_RUN=true
MEDIA_DIR="/mnt/user/data/media/tv"

find "$MEDIA_DIR" -type d | while read dir; do
    # Collect all video base names in this folder
    mapfile -t videos < <(find "$dir" -maxdepth 1 -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \))

    [ ${#videos[@]} -eq 0 ] && continue

    # Loop through subtitle files
    find "$dir" -maxdepth 1 -type f \( -iname "*.srt" -o -iname "*.ass" -o -iname "*.sub" \) | while read sub; do
        subbase=$(basename "$sub")
        match_found=false

        for video in "${videos[@]}"; do
            vidbase=$(basename "$video")
            vidname="${vidbase%.*}"

            if [[ "$subbase" == "$vidname"* ]]; then
                match_found=true
                break
            fi
        done

        if [ "$match_found" = false ]; then
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY RUN] Would delete: $sub"
            else
                echo "Deleting: $sub"
                rm "$sub"
            fi
        fi
    done
done
