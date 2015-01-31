class ProgressManager
  attr_reader :students, :assignments

  def initialize(students, assignments)
    @students    = students
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
end
