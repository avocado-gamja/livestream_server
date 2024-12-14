#!/bin/bash

# RTMP Stream Source
STREAM_URL="rtmp://localhost:1935/live"

# Output Directory
OUTPUT_DIR="/home/ahn/workspace/liveStreamData"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Start extracting images from the RTMP stream
echo "Starting to process RTMP stream and save images to $OUTPUT_DIR"

ffmpeg -i "$STREAM_URL" -vf "fps=1/5" "$OUTPUT_DIR/frame_%03d.jpg"


