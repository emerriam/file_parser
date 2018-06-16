#!/usr/bin/env ruby
require 'test/unit'
require './file_parser.rb'

class FileParserTest < Test::Unit::TestCase
  def test_new_file_parser_initialize
    file = 'testformat1_2015-06-28.txt'
    df = FileParser.new(file_name: file)
    assert_equal(ExampleTable.count, 3)
  end

  def test_database_completeness
    assert_equal(ExampleTable.first.name, 'Foonyor   ')
    assert_equal(ExampleTable.first._valid, true)
    assert_equal(ExampleTable.first.count, 1)

    assert_equal(ExampleTable.second.name, 'Barzane   ')
    assert_equal(ExampleTable.second._valid, false)
    assert_equal(ExampleTable.second.count, -12)

    assert_equal(ExampleTable.third.name, 'Quuxitude ')
    assert_equal(ExampleTable.third._valid, true)
    assert_equal(ExampleTable.third.count, 103)
  end
end
