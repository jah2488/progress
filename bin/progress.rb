require 'formatador'
require_relative '../lib/assignment'
require_relative '../lib/student.rb'
require_relative '../lib/progress_manager.rb'

STUDENTS = [
  Student.new('buck', 0, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  false, true),
    Assignment.new('lab 1', false, true),
    Assignment.new('w2d1',  false, true),
  ]),
  Student.new('drew', 0, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  true,  false),
    Assignment.new('lab 1', false, false),
    Assignment.new('w2d1',  false, true),
  ]),
  Student.new('jacob', 0, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  false, false),
    Assignment.new('lab 1', false, true),
    Assignment.new('w2d1',  false, true),
  ]),
  Student.new('justin', 0, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  true,  false),
    Assignment.new('lab 1', false, false),
    Assignment.new('w2d1',  false, false),
  ]),
  Student.new('kate', 0, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  false, true),
    Assignment.new('lab 1', false, true),
    Assignment.new('w2d1',  false, true),
  ]),
  Student.new('kelly', 4, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  true, false),
    Assignment.new('lab 1', true, false),
    Assignment.new('w2d1',  true, false),
  ]),
  Student.new('rob', 0, 2, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  true,  true),
    Assignment.new('w1d3',  false, true),
    Assignment.new('lab 1', false, false),
    Assignment.new('w2d1',  false, false),
  ]),
  Student.new('roel', 0, 0, [
    Assignment.new('w1d1',  false, true),
    Assignment.new('w1d2',  false, true),
    Assignment.new('w1d3',  false, true),
    Assignment.new('lab 1', false, true),
    Assignment.new('w2d1',  false, true),
  ]),

]

sorted = STUDENTS.sort_by { |x| [x.completed, x.late, x.name]}.reverse

pm = ProgressManager.new(sorted)

pm.run



