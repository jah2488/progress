class ProgressManager
  attr_reader :students, :assignments

  def initialize(students, assignments)
    @students = students
    @assignments = assignments
    @vm = ViewManager.new
  end

  def run
    @vm.view_stack.push(TestView.new(@vm))
    @vm.view_stack.push(MenuView.new(@vm, students: @students))
    loop do
      system('clear')
      @vm.present
      response = @vm.prompt
      @vm.action(response)
    end
    menu_view
  end

  def add_assignment_view
    assignment ||= {}
    ui_loop do |input|
      puts 'Add Assignment'
      Assignment.attributes.each do |attr|
        puts assignment[attr]
        assignment[attr] = get("< #{attr} >")
      end
      break
    end
    REPO.save(:assignments, assignment)
  end

  def add_student_view
    student ||= {}
    ui_loop do |input|
      puts 'Add Student'
      Student.attributes.each do |attr|
        next if attr == :submissions
        puts student[attr]
        student[attr] = get("< #{attr} >")
      end
      break
    end
    REPO.save(:students, student)
  end

  def add_submission_view
    # submissions should really be a 'join table' this (now legacy) nested thing isn't working out.
    student_record = nil
    ui_loop do |input|

      puts 'Add Submission to which student?'
      avail_students = students.reject { |s| s.submissions.length >= REPO[:assignments].length }
      avail_students.each_with_index do |student, index|
        puts "#{index}) #{student.name}"
      end
      student_record = avail_students[get('>', '0').to_i]

      puts "Which assignment for #{student_record.name}?"
      filtered = assignments.reject { |a| student_record.submissions.any? { |s| s.title == a.opts[:id] } }
      filtered.each_with_index do |assignment, index|
        puts "#{index}) #{assignment.title}"
      end
      assignment = filtered[get('>', '0').to_i]

      submission = Submission.new(title: assignment.opts[:id])

      is_late = get('< late (y/[light_cyan]n[/]) >', 'n')
      is_complete = get('< complete ([light_cyan]y[/]/n) >', 'y')

      submission.late = !!(is_late =~ /[y|yes]/)
      submission.complete = !!(is_complete =~ /[y|yes]/)


      puts "#{student_record.name} - #{assignment.title}"
      puts submission.to_h

      if !!(get('< Correct? ([light_cyan]y[/]/n) >', 'y') =~ /[y|yes]/)
        student_record.add_submission(submission)
        break
      end
    end
    REPO.update(:students, student_record)
  end

  private
  def ui_loop(&block)
    loop do
      system('clear')
      block.call('')
    end
  end

end
