class MenuView < View
  def present
    puts '---- Student and Assignment progress tracker ----'
    puts 'Add (s)tudent, (a)ssignment, add s(u)bmission [p to progress, q to quit, ! to debug]'
    puts 'Add a(b)sense, (t)ardy'
    super
  end

  def action(response)
    case response
    when 'p' then @vm.view_stack.push(ProgressView.new(@vm, students: @students))
    when 'h' then puts "Help! Help! I'm being oppressed!"
    when 's' then @vm.view_stack.push(AddStudentView.new(@vm))
    when 'u' then @vm.view_stack.push(AddSubmissionView.new(@vm, students: @students, assignments: @assignments))
    when 'a' then @vm.view_stack.push(AddAssignmentView.new(@vm))
    when 'b' then @vm.view_stack.push(AddAbsenseView.new(@vm, students: @students))
    when 't' then @vm.view_stack.push(AddTardyView.new(@vm, students: @students))
    when '!' then require 'pry'; binding.pry
    else
      super(response)
    end
  end
end
