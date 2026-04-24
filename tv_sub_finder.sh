#!/bin/bash

main() {
set -euo pipefail

DRY_RUN=true
MEDIA_DIR="/mnt/user/data/media/tv"
count=0

while IFS= read -r -d '' dir; do

    # Collect all videos in this folder
    mapfile -t videos < <(find "$dir" -maxdepth 1 -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) -print0 | tr '\0' '\n')
    [ ${#videos[@]} -eq 0 ] && continue

    while IFS= read -r -d '' sub; do
        subbase=$(basename "$sub")
        # Strip subtitle extension then language tags (.en, .hi, .en.hi etc)
        subname="${subbase%.*}"
        subname=$(printf '%s' "$subname" | sed 's/\(\.[a-z]\{2,3\}\)\+$//')

        match_found=false
        for video in "${videos[@]}"; do
            vidbase=$(basename "$video")
            vidname="${vidbase%.*}"
            if [[ "$subname" == "$vidname" ]]; then
                match_found=true
                break
            fi
        done

        if [ "$match_found" = false ]; then
            if [ "$DRY_RUN" = true ]; then
                printf '[DRY RUN] Would delete: %s\n' "$sub"
            else
                printf 'Deleting: %s\n' "$sub"
                rm "$sub"
            fi
            ((count++))
        fi
    done < <(find "$dir" -maxdepth 1 -type f \( -iname "*.srt" -o -iname "*.ass" -o -iname "*.sub" \) -print0)

done < <(find "$MEDIA_DIR" -mindepth 1 -type d -print0)

printf '\nDone. %d file(s) %s.\n' "$count" "$([ "$DRY_RUN" = true ] && echo 'would be deleted' || echo 'deleted')"
}

main 2>&1 | less
