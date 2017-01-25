#!/usr/bin/env bash

for path in $( ls scans/*.jpg ); do
    mkdir -p scans/output
    filename=$(basename $path)
    echo PREPROCESSING IMAGE $filename
    ./opencv.js $path "scans/output/${filename}"
    echo "RUNNING OCR ON scans/output/${filename}"
    tesseract -psm 6 scans/output/${filename} scans/output/${filename} config
    echo "SANITIZING NUMBERS FOR scans/output/${filename}.txt"
    ./fixnumbers.js scans/output/${filename}.txt
done