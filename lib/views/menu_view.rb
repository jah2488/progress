class MenuView < View
  def present
    puts '---- Student and Assignment progress tracker ----'
    puts 'Add (s)tudent, (a)ssignment, add s(u)bmission [p to progress, q to quit, ! to debug]'
    puts 'Add a(b)sense, (t)ardy'
    super
  end

  def action(response)
    case response
    when 'p' then @vm.navigate(ProgressView, students: @students)
    when 'h' then puts "Help! Help! I'm being oppressed!"
    when 's' then @vm.navigate(AddStudentView)
    when 'u' then @vm.navigate(AddSubmissionView, students: @students, assignments: @assignments)
    when 'a' then @vm.navigate(AddAssignmentView)
    when 'b' then @vm.navigate(AddAbsenseView, students: @students)
    when 't' then @vm.navigate(AddTardyView, students: @students)
    when '!' then require 'pry'; binding.pry
    else
      super(response)
    end
  end
end
