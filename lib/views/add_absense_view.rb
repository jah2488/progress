class AddAbsenseView < View
  def present
    puts 'Add absense to which student?'
    @students.each_with_index do |student, index|
      puts "#{index}) #{student.name} - #{student.absenses}"
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
    @vm.navigate(ConfirmView,
                 on_present: -> do
                   puts @students[response.to_i].name
                 end,
                 on_confirm: -> do
                   student = @students[response.to_i]
                   student.add_absense
                   REPO.update(:students, student)
                 end)
  end
end
