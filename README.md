# ocr-test

## Prerequisites

1. Tesseract 3
2. ImageMagick

## Steps to Training
1. Drop the scanned images for a particular state in the `training/input_images` folder
2. run `./preprocess.sh` to generate the training images
3. open `jTessBoxEditorFX` java program and edit the box files to be accurate for images in the `training_images/processed` folder (make sure to save as and overwrite after you edit the box values)
4. `cd training` and edit the `train.sh` file's last line to indicate where you want to move the finalized trained language file to. This should be the `tessdata` folder of wherever tesseract is installed
4.1 the script is precoded to receipt_nh as the output language name. You can change that in the `train.sh` file
5. run `./train.sh` and you're done! the new language file will be copied to tessdata and available to the tesseract command using the `-l` flag

Happy OCRing
