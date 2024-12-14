#!/bin/bash

if [ -d "$1" ]; then
    # If it's a directory, open it directly
    dolphin "$1"
else
    # If it's a file, open the containing directory
    dolphin "$(dirname "$1")"
fi
