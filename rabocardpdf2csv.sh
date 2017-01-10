#!/bin/bash

tempfile=temp.csv
outputfile=alltransactions.csv


echo "Converting Rabobank creditcard transaction pdf-files into text files, extracting the relevant transaction information, and collecting into a single text file."
echo "Assumptions:"
echo "  . Pdf-files with names like 'Overzicht creditcard augustus 2016.pdf', in folder 'input'"
echo "Actions:"
echo "  . Copy and rename pdf like '2016-08.pdf', in folder 'output'"
echo "  . Extract data into text file like '2016-08.txt', in folder 'output'"
echo "  . Collect data into single text file ($outputfile) in this folder"
echo "Conditions:"
echo "  . $outputfile does not exist yet."
echo ""

if [ -e $outputfile ]; then
  echo "Error: the output file ($outputfile) does already exist. Exiting script."
  exit 1
fi
rm -f $tempfile
echo "Processing single files..."
for file in input/*.pdf; do
  echo "  processing file $file "
  name=${file##*/}  #remove part up to and including last '/'
  base=${name%.pd*} #remove part after and including '.pd'
  monthyear=${base#*creditcard } #remove part up to and including 'creditcard '
  month=${monthyear% *}
  case ${month:0:3} in
    "jan") month='01';;
    "feb") month='02';;
    "maa") month='03';;
    "apr") month='04';;
    "mei") month='05';;
    "jun") month='06';;
    "jul") month='07';;
    "aug") month='08';;
    "sep") month='09';;
    "okt") month='10';;
    "nov") month='11';;
    "dec") month='12';;
    *)
      echo "Error: month not found. Exiting script."
      exit 1;;
  esac
  year=${monthyear#* }
  if ! [[ $year =~ ^[0-9]{4}$ ]]; then
    echo "Error: year not found. Exiting script."
    exit 1
  fi
  newfile=output/$year-$month
  pdftotext -layout "$file" "$newfile.txt" -y 310 -x 2 -W 800 -H 1000
  cp "$file" "$newfile.pdf"
done
echo "...done"

echo ""
echo "Putting all transactions into 1 file..."
for file in output/*.txt; do
  echo "  processing file $file ..."
  grep -E '^[0-9]{2}-[0-9]{2}-[0-9]{4} .*$' "$file" >> $tempfile
done
echo "...done."

echo ""
echo "Turning into csv format..."
regex='^([0-9]{2}-[0-9]{2}-[0-9]{4})\s+(.*)\s+(-?[0-9]*,[0-9]{2})$'
while read tr; do
  echo $tr
  if [[ $tr =~ $regex ]]; then
    date=${BASH_REMATCH[1]}
    desc=${BASH_REMATCH[2]}
    quan=${BASH_REMATCH[3]/,/.}
    echo $date,"\""$desc"\"",$quan >> $outputfile
  else
    echo "Error: no match found on line. Exiting script. Offending line:"
    echo $tr
    exit 1
  fi
done <$tempfile
rm -f $tempfile
echo "...done"

echo ""
echo "Done extracting all transactions. Result in $outputfile."
exit 0
