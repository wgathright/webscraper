#!/bin/bash
#web scraping quotes site 

if [ $# -ne 1 ]; then
	echo "Usage $(basename $0) 'Author Name'"
	exit -1
fi


curl=$(which curl)
outfile="output.txt"
name=$(echo $1 | tr ' ' '+')
url="https://www.goodreads.com/quotes/tag/$name"

#dump webpage
function dump_webpage()
{
	$curl -o $outfile $url &>/dev/null
	check_errors
}

#clean the webpage
function strip_html()
{
	grep -v href $outfile | grep -A1 authorOrTitle | grep -v authorOrTitle > temp.txt && cp temp.txt $outfile

}

#looping through content of file
function print_quotes()
{
	echo "All authors!"
	while read quote; do
		echo "${quote}"
	done < $outfile
}

#checking for errors
function check_errors()
{
	[ $? -ne 0 ] && echo "Error Downloading Page..." && exit -1
}


###########################################
#                   MAIN                  #
###########################################

dump_webpage
strip_html
print_quotes

#END