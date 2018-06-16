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