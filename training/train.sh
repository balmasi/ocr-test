#!/usr/bin/env bash

input_language="eng"
output_language="receipt_nh"
output_font="nh_powerball_font"

processed_img_path="training_images/processed"
training_data_path="training_data"

unicharset_output="${output_language}.unicharset"
font_properties_output="${output_language}.font_properties"

mkdir -p ${training_data_path}
for img in $( ls ${processed_img_path}/*.tif ); do
    basename_no_ext=$( basename "${img%.tif}" )
    sample_number=$(echo ${basename_no_ext} | sed 's/[^0-9]*//g')
    tesseract -psm 6 ${img} ${training_data_path}/${output_language}.${output_font}.exp${sample_number} box.train config
done


# create the language specific font properties
cp font_properties.template ${font_properties_output}
echo "\n${output_language}.${output_font}.box 0 0 1 0 0" >> $font_properties_output

# Create unicharset file
unicharset_extractor ${processed_img_path}/*.box

# Set unicharset properties
set_unicharset_properties -F ${font_properties_output} -U unicharset -O ${unicharset_output} --script_dir=langdata
rm unicharset

# Shape Clustering
shapeclustering -F ${font_properties_output} -U ${unicharset_output} ${training_data_path}/*.tr

# Shape Table
mftraining -F ${font_properties_output} -U ${unicharset_output} ${training_data_path}/*.tr

# Char Prototypes
cntraining ${training_data_path}/*.tr

# Make wordlist
wordlist2dawg wordlist.template ${output_language}.word-dawg ${output_language}.unicharset

# Create language specific files
mv inttemp ${output_language}.inttemp
mv normproto ${output_language}.normproto
mv pffmtable ${output_language}.pffmtable
mv shapetable ${output_language}.shapetable

# Create final training file
combine_tessdata ${output_language}.


# mv
mv ./${output_language}.traineddata /usr/local/Cellar/tesseract/3.04.01_2/share/tessdata