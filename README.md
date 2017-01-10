# rabocardPdf2Csv
Script to extract transaction information from Rabobank PDF bank statements into CSV. 

## The Problem

For 'Rabo Totaalrekening', 'Rabo Spaarrekening' etc, the Dutch bank Rabobank offers downloading the transactions as CSV files, for import into accounting software (e.g., [Gnucash](https://www.gnucash.org/)).

For the Mastercard ('Rabocard') statements, however, only PDF files can be downloaded, which cannot be easily imported anywhere. Here is an example:
![pdf](pdf.png)

## The Solution

The bash script `rabocardpdf2csv.sh` takes the pdf files in the `input` folder, processes them and puts them into the `output` folder. Then, all transactions in these files are put into the file `alltransactions.csv`:
![csv](csv.png)


## Dependencies

The program `pdftotext` is needed. On Ubuntu, it is installed with `sudo apt install pdftotext`.
