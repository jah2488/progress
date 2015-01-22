class AddAssignmentView < View
  def present
    puts 'Add Assignment'
    @attrs = Assignment.attributes.each
    @current_attr = @attrs.next
    @assignment = {}
  end

  def prompt
    get("< #{@current_attr} >")
  end

  def action(response)
    @assignment[@current_attr] = response
  end
end
