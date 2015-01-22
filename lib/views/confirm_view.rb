class ConfirmView < View
  def present
    @on_present.call
    super
  end

  def prompt
    get('< Are you sure(y/n) >')
  end

  def action(response)
    if response =~ /y/
      @on_confirm.call
    end
    @vm.back
  end
end

