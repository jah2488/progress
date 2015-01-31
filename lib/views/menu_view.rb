class MenuView < View
  def present
    puts '---- Student and Assignment progress tracker ----'
    puts 'Add (s)tudent, (a)ssignment, add s(u)bmission [p to progress, q to quit, ! to debug]'
    puts 'Add a(b)sense, (t)ardy'
    super
  end

  def action(response)
    case response
    when 'p' then navigate(ProgressView, students: @students)
    when 'h' then say "Help! Help! I'm being oppressed!"
    when 's' then navigate(AddStudentView)
    when 'u' then navigate(AddSubmissionView, students: @students, assignments: @assignments)
    when 'a' then navigate(AddAssignmentView)
    when 'b' then navigate(AddAbsenseView, students: @students)
    when 't' then navigate(AddTardyView, students: @students)
    when '!' then require 'pry'; binding.pry
    else
      super(response)
    end
  end
end
