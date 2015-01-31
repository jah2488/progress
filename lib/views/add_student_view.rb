class AddStudentView < View

  def initialize(vm, **opts)
    super(vm, **opts)

    @attrs = Student.attributes.each
    @current_attr = @attrs.next
    @student   = {}
  end

  def present
    puts 'Add Student'
    puts @student.inspect
  end

  def prompt
    get("< #{@current_attr} >")
  end

  def action(response)
    @student[@current_attr] = response
    @current_attr = @attrs.next
    @current_attr = @attrs.next if @current_attr == :submissions
  rescue StopIteration => _ #Stop Iteration is handled by Kernel#loop
    REPO.save(:students, @student)
    @vm.back
  end

end
