$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + '/../lib')
Dir[File.expand_path(File.dirname(__FILE__)) + '/../lib/**/*.rb'].map do |file|
  require_relative file
end
require 'formatador'
require 'json'


REPO = Repository.new
  .register_type(Assignment, 'data/assignments.json', true)
  .register_type(Student, 'data/students.json', true)

ProgressManager.new(REPO[:students], REPO[:assignments]).run
