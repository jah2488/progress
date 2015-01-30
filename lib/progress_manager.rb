class ProgressManager
  attr_reader :students, :assignments

  def initialize(students, assignments)
    @students = students
    @assignments = assignments
    @vm = ViewManager.new
  end

  def run
    @vm.navigate(MenuView, students: @students, assignments: @assignments)
    loop do
      system('clear')
      @vm.present
      @vm.action(@vm.prompt)
    end
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

  private
  def ui_loop(&block)
    loop do
      system('clear')
      block.call('')
    end
  end

end
