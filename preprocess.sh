#!/usr/bin/env bash

counter=0
state="nh"
input_images_folder="training/input_images"
training_image_folder="training/training_images"
processed_image_folder="$training_image_folder/processed"

if [ ! -d "node_modules/opencv" ]; then
    echo "OpenCV nodejs bindings not detected."
    echo "Installing OpenCV Dependency (requires node.js and npm)"
    echo "Tested with node v6.5 √"
    npm install
fi

# Make the appropriate folders
mkdir -p "$training_image_folder/processed"

for path in $( ls ${input_images_folder}/*.jpg ); do
    image_name="eng.${state}_powernall_font.exp${counter}.tif"
    training_image_path="$training_image_folder/$image_name"
    processed_image_path="$processed_image_folder/$image_name"

    # Convert to .tif
    convert "$path" -auto-level -compress none ${training_image_path}
    ((counter++))

    # Isolate ROI
    echo "PREPROCESSING IMAGE $training_image_path. Saving to $processed_image_folder"
    ./opencv.js ${training_image_path} ${processed_image_path}

    # Create boxfiles
    echo "CREATING OCR BOXFILE FOR ${processed_image_path}"
    tesseract -psm 6 ${processed_image_path} "${processed_image_path%.tif}" batch.nochop makebox config
done

echo "Now, please edit the boxfiles using jTessBoxEditorFX Java program and then run ./train.sh"