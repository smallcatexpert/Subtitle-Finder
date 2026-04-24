#!/bin/bash
set -euo pipefail

# Set to false to actually delete
DRY_RUN=true
MEDIA_DIR="/mnt/user/data/media/movies"

count=0

while IFS= read -r -d '' dir; do
    # Get the main video file (assumes one per folder)
    video=$(find "$dir" -maxdepth 1 -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) -print0 | { IFS= read -r -d '' f && printf '%s' "$f"; } || true)
    [ -z "$video" ] && continue

    vidbase=$(basename "$video")
    vidname="${vidbase%.*}"

    # Loop through subtitle files in that folder
    while IFS= read -r -d '' sub; do
        subbase=$(basename "$sub")
        if [[ "$subbase" != "$vidname"* ]]; then
            if [ "$DRY_RUN" = true ]; then
                printf '[DRY RUN] Would delete: %s\n' "$sub"
            else
                printf 'Deleting: %s\n' "$sub"
                rm "$sub"
            fi
            ((count++))
        fi
    done < <(find "$dir" -maxdepth 1 -type f \( -iname "*.srt" -o -iname "*.ass" -o -iname "*.sub" \) -print0)

done < <(find "$MEDIA_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

printf '\nDone. %d file(s) %s.\n' "$count" "$([ "$DRY_RUN" = true ] && echo 'would be deleted' || echo 'deleted')"
