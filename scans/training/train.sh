#!/usr/bin/env bash

for f in *.jpg; do  echo "Converting $f"; convert "$f"  "$(basename "$f" .jpg).tif"; done

for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13; do
  tesseract eng.powerballfont.exp${i}.tif receipt.powerballfont.exp${i} box.train
done

# Create unicharset file
unicharset_extractor *.box

# Set unicharset properties
set_unicharset_properties -F font_properties -U unicharset -O receipt.unicharset --script_dir=langdata

# Shape Clustering
shapeclustering -F font_properties -U receipt.unicharset *.tr

# Shape Table
mftraining -F font_properties -U receipt.unicharset *.tr

# Char Prototypes
cntraining *.tr

# Create language specific files
mv inttemp receipt.inttemp
mv normproto receipt.normproto
mv pffmtable receipt.pffmtable
mv shapetable receipt.shapetable

# Create final training file
combine_tessdata receipt.



# mv
mv ./receipt.traineddata /usr/local/Cellar/tesseract/3.04.01_2/share/tessdata