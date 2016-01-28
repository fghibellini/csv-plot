#!/bin/bash

export usage="Usage: $0 [-o | --output-file <filename>] [-H | --headers <headers>] [-s | --separator <separator>] [-h | --help]

Plots the data stored in a csv file using gnuplot.
The first column is used as the independent variable,
all the other columns are plotted as separate lines.

Options:

  -o, --output-file
      The name of the file to store the plot in.
      Default is "plot.png".

  -H, --headers
      A comma separated list of headers.
      If not supplied the first line of the csv file is used.

  -s, --separator
      Specifies the csv field separator.
      Default is ",".

  -h, --help
      Prints this message.

Examples:
    $0 -o graph1.png -H "x,y1,y2,y3" < data.csv

Author: Filippo Ghibellini <f.ghibellini@gmail.com>
License: MIT (https://opensource.org/licenses/MIT)"

export separator=','
export output_filename='plot.png'
export args_headers=false
export titles=()

####################
# ARGUMENT PARSING #
####################

while [[ $# -gt 0 ]]; do
    case $1 in
        -H|--headers)
            args_headers=true
            titles=( $(echo -n $2 | tr ',' '\n') )
            shift
            ;;
        -H|--headers)
            separator=$2
            shift
            ;;
        -o|-O|--output-file)
            output_filename="$2"
            shift
            ;;
        -?|-h|--help)
            echo "$usage"
            exit 0
            ;;
        *)
            echo "Unknown argument '$1'!" >2
            exit 1
            ;;
    esac
    shift
done

#####################
# CONFIG PROCESSING #
#####################

if ! $args_headers; then
    # don't use head here since it consumes more than a line
    read line
    titles=( $(echo "$line" | tr ',' '\n') )
fi

#############
# EXECUTION #
#############

# it seems that the process substitution breaks the stdin
# so we just use a different file descriptor
exec 7<&0

gnuplot <(cat <<EOF
    # output to file
    set terminal png
    set output "$output_filename"

    # csv field separator
    set datafile separator "$separator"
    # style
    set style data linespoints

    # plot the columns
    plot $(for (( n=1; n < ${#titles[@]}; n++ )); do
        # print the data source
        echo -n "'<&7' using 1:$((n+1)) title \"${titles[n]}\""
        # join by commas
        (( n < ${#titles[@]} - 1 )) && echo -n ', '
    done)
EOF
)
