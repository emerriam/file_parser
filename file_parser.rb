#!/usr/bin/env ruby
require './database'
require 'csv'
require 'byebug'

class FileParser < ActiveRecord::Migration[5.1]
  attr_accessor :file_name, :file_type, :date, :csv_format, :specs, :data_file, :csv_table

  def initialize(args = {})
    args.each do |key, value|
      send("#{key}=", value)
    end
    @csv_format, @date, @file_type = parse_file_name
    @specs ||= load_spec_file
    @data_file ||= read_data_file
    merge_data_spec
  end

  private

  def merge_data_spec
    csv_array = []

    data_file.each do |row|
      csv_array.push(parse_row(row))
    end

    @csv_table = CSV::Table.new(csv_array)
    # Run the migration
    change

    @csv_table.each do |row|
      ExampleTable.create(row.to_hash)
    end
  end

  def parse_row(row)
    char_index = 0
    item_array = []
    specs.each_with_index do |spec, index|
      item = convert_item(spec, row[0][char_index, specs[index][1].to_i])
      item_array << item
      char_index += specs[index].fetch('width').to_i
    end

    CSV::Row.new(specs.by_col[0], item_array, header_row = false)
  end

  def convert_item(spec, item)
    case spec.fetch('datatype')
    when 'TEXT'
      item.to_s
    when 'BOOLEAN'
      item.strip
    when 'INTEGER'
    item_array = []
      item.strip.to_i
    end
  end

  def change
    create_table :example_tables, force: true do |t|
      create_columns(t)
    end
  end

  def create_columns(t)
    specs.each do |column|
      width, datatype, column_name = interpret_spec(column)
      t.send(datatype.downcase, column_name)
    end
  end

  def interpret_spec(column)
    width = 0
    datatype = ''
    column_name = ''

    width = column.fetch('width').to_i if column.key?('width')

    column_name = column.fetch('column name').to_s if column.key?('column name')

    datatype = column.fetch('datatype').to_s if column.key?('datatype')

    [width, datatype, column_name]
  end

  def parse_file_name
    file_format = /(testformat[0-9])_(2015-06-28)\.([A-z][A-z][A-z])/.match(file_name)
    [file_format[1], file_format[2], file_format[3]]
  end

  def load_spec_file
    csv_spec = File.read("specs/#{csv_format}.csv")

    CSV::Converters[:insert_underscore] = lambda do |row|
      row = row == 'valid' ? '_valid' : row
    end

    CSV.parse(csv_spec, converters: :insert_underscore, headers: true)
  end

  def read_data_file
    csv_text = File.read("data/#{file_name}")
    CSV.parse(csv_text, headers: false)
  end
end

# Load in the example files
file = 'testformat1_2015-06-28.txt'
data_file = FileParser.new(file_name: file)
