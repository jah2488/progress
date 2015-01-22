class AddTardyView < View
  def present
    puts 'Add tardy to which student?'
    @students.each_with_index do |student, index|
      puts "#{index}) #{student.name} - #{student.tardies}"
    end
    super
  end

  def action(response)
    confirm = -> {
      student = @students[response.to_i]
      student.add_tardy
      REPO.update(:students, student)
    }
    case response
    when '0'..@students.length.to_s then @vm.view_stack.push(ConfirmView.new(@vm, on_present: -> { puts @students[response.to_i].name }, on_confirm: confirm))
    else
      super(response)
    end
  end
end
