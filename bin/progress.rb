require 'formatador'
require 'json'
require_relative '../lib/repository'
require_relative '../lib/record'
require_relative '../lib/assignment'
require_relative '../lib/submission'
require_relative '../lib/student'
require_relative '../lib/progress_manager'

REPO = Repository.new
REPO.register_type(Assignment, 'data/assignments.json', true)
    .register_type(Student, 'data/students.json', true)

ProgressManager.new(REPO[:students], REPO[:assignments]).run
