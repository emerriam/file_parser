## Problem definition

You receive drops of data files and specification files. Write an application
in the language of your choice that will load these files into a database.

## Problem details

Data files will be dropped in the folder "data/" relative to your application
and specification files will be dropped in the folder "specs/" relative to
your application.

Specification files will have filenames equal to the file type they specify and
extension of ".csv". So "fileformat1.csv" would be the specification for files
of type "fileformat1".

Data files will have filenames equal to their file format type, followed by
an underscore, followed by the drop date and an extension of ".txt". 
For example, "fileformat1_2007-10-01.txt" would be a
data file to be parsed using "specs/fileformat1.csv", which arrived on 10/01/2007.

Format files will be csv formated with columns "column name", "width", and
"datatype". 

* "column name" will be the name of that column in the database table  
* "width" is the number of characters taken up by the column in the data file  
* "datatype" is the SQL data type that should be used to store the value
in the database table.

Data files will be flat text files with rows matching single records for the
database. Rows are formatted as specified by the associated format file.

## Examples

This is an example file pair; other files may vary in structure while still
fitting the structure of the problem details (above):

specs/testformat1.csv

```text
"column name",width,datatype
name,10,TEXT
valid,1,BOOLEAN
count,3,INTEGER
```

data/testformat1_2015-06-28.txt

```text
Foonyor   1  1
Barzane   0-12
Quuxitude 1103
```

Sample table output: 
```text
name      | valid | count 
--------- | ----- | -----
Foonyor   | True  |     1 
Barzane   | False |   -12 
Quuxitude | True  |   103 
```

## Expectations

ation can be written with language/libraries of your choosing. Take this opportunity to best demonstrate your talents!
- Database type and connection mechanism is left to your discretion.
- You should include tests that cover, at least, the examples given.
- You should implement the conversions for the SQL data types: TEXT, BOOLEAN,
and INTEGER
- Files can be assumed to use UTF-8 encoding
- You should be prepared to discuss implementation decisions and possible
extensions to your application.


## Description

Due to time constraints the program acheives the bare minimum of the specifications.  There is no significant error handling or validation.

Steps: 
1. A non-persistent database is created in memory with a single table and model, "ExampleTable"
1. An instance of the FileParser class is created, accepting the file name of the data file as it's only parameter.
1. All of the functions of the program are initiated in the initialize method when the class is created.
	* The FileParser class extends Ruby's ActiveRecord::Migration, making it really just a customized migration
	* Instance variables @csv_format, @date, @file_type are set by the method *parse_file_name*
	* The Specification File is loaded into instance variable @specs by *load_spec_file*
	* The Data File is loaded into instance variable @data_file by *read_data_file*
	* The Data File is converted into a CSV table as interpreted by the Specifications File *merge_data_spec*
	* Migration functions are initiated and executed by ActiveRecord::Migration.change within *merge_data_spec*

## Future Development and Optimization

### Must-haves

* Refactor to minimize the line-count of code in each method; break up distinct functionality within methods
* Tests for all methods
* Error checking to ensure that the Specifications File and Data File are structured within parameters the code can except
* Tracking of which Data Files have been executed, dates, types, success/failure, errors, file names
* A server to automatically kick off execution as soon as a Data File is dropped into the /data directory
* Ability to add elements to an existing table 
* Checks for duplicate table entries when multiple files are processed
* Tests mocking variations of Spec/Data files

### Nice-to-haves
Depending on expected use cases, some ideas for improvement.
* Error recovery correcting certain types of invalid data files (typos in file name, extra white space, etc.)
* User feedback and options for error recovery during execution
* Browser interface to display tables after their creation
* Static table names based on Specification File


## Running File Parser

At the command prompt, enter:
```text
ruby file_parser.rb
```

## Running Tests
At the command prompt, enter:
```text
ruby file_parser_test.rb
```