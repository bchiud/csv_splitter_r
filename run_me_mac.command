#!/bin/sh

echo -n -e "\033]0;CSV Splitter\007"

cd -- "$(dirname "$0")"

function intput_file_getter() {
    input_file_name=$(osascript << EOT
            tell application "Finder"
                    activate
                    set response to text returned of (display dialog "Enter name of file to be processed :" default answer "mock_csv_file.csv" with title "CSV Splitter")
                    return response
            end tell
    EOT)
}

function output_rows() {
    rows=$(osascript << EOT
            tell application "Finder"
                    activate
                    set response to text returned of (display dialog "Enter the number of rows per output file:" default answer "10000" with title "CSV Splitter")
                    return response
            end tell
    EOT)
}

intput_file_getter
output_rows
echo "Processing $input_file_name..."

Rscript code/csv_splitter.R $input_file_name $rows