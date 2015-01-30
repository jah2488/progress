class AddTardyView < View
  def present
    puts 'Add tardy to which student?'
    @students.each_with_index do |student, index|
      puts "#{index}) #{student.name} - #{student.tardies}"
    end
    super
  end

  def action(response)
    case response
    when '0'..@students.length.to_s then confirm_add(response)
    else
      super(response)
    end
  end

  def confirm_add(response)
    on_present = -> { puts @students[response.to_i].name }
    on_confirm = -> do
      student = @students[response.to_i]
      student.add_tardy
      REPO.update(:students, student)
    end
    @vm.navigate(ConfirmView, on_present: on_present, on_confirm: on_confirm)
  end
end
