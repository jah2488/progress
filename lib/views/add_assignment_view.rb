class AddAssignmentView < View

  def initialize(vm, **opts)
    super(vm, **opts)

    @attrs = Assignment.attributes.each
    @current_attr = @attrs.next
    @assignment   = {}
  end

  def present
    puts 'Add Assignment'
    puts @assignment.inspect
  end

  def prompt
    get("< #{@current_attr} >")
  end

  def action(response)
    @assignment[@current_attr] = response
    @current_attr = @attrs.next
  rescue StopIteration => _ #Stop Iteration is handled by Kernel#loop
    REPO.save(:assignments, @assignment)
    @vm.back
  end
end
