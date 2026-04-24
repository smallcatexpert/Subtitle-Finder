# Subtitle-Finder

## Description
This script will find and delete subtitles that don't match the movie name in the folder. Useful for running after an upgrade in radarr. This works with the TRaSH guides naming convention and folder format.

## Instructions

### Media Directory
Update MEDIA_DIR to match name of your movie directory. It is setup to match the TRaSH guides recommended directory by default of /mnt/user/data/media/movies. If not on Unraid remove /mnt/user so your location will be /data/media/movies.

### Script Instructions
Script is in dry run mode by default. Change dry_run=false to delete subtitle files.
