# Subtitle-Finder

## Description
These scripts will find and delete subtitles that don't match the filename in your movie or tv season folders. Useful for running after an upgrade in radarr or sonarr. This works with the TRaSH guides naming convention and folder format.

## Instructions

### Media Directory
Update MEDIA_DIR to match name of your directory. It is setup to match the TRaSH guides recommended directory by default of /mnt/user/data/media/movies for movies and /mnt/user/data/media/tv for shows. If not on Unraid remove /mnt/user so your location will be /data/media/movies or /data/media/tv.

### Script Instructions
Script is in dry run mode by default. Change dry_run=false to delete subtitle files.
