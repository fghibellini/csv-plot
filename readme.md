
# csv-plot.sh

__Usage:__ ./csv-plot.sh [-o | --output-file <filename>] [-H | --headers <headers>] [-s | --separator <separator>] [-h | --help]

Plots the data stored in a csv file using gnuplot.
The first column is used as the independent variable,
all the other columns are plotted as separate lines.

__Options:__

  -o, --output-file
      The name of the file to store the plot in.
      Default is plot.png.

  -H, --headers
      A comma separated list of headers.
      If not supplied the first line of the csv file is used.

  -s, --separator
      Specifies the csv field separator.
      Default is ,.

  -h, --help
      Prints this message.

__Examples:__
    ./csv-plot.sh -o graph1.png -H x,y1,y2,y3 < data.csv

__Author:__ Filippo Ghibellini <f.ghibellini@gmail.com>

__License:__ MIT (https://opensource.org/licenses/MIT)
