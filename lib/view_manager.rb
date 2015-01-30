class ViewManager
  attr_accessor :view_stack
  def initialize(vs = [])
    @view_stack = vs
  end

  def navigate(view, **kwargs)
    @view_stack.push(view.new(self, **kwargs))
  end

  def back
    @view_stack.pop
  end

  def present
    if @view_stack.empty?
      puts 'Goodbye'
    else
      @view_stack.last.present
    end
  end

  def prompt
    if @view_stack.empty?
      gets.chomp
    else
      @view_stack.last.prompt
    end
  end

  def action(response)
    if @view_stack.empty?
      case response
      when 'q' then puts 'cya'; exit!
      else
        exit!
      end
    else
      @view_stack.last.action(response)
    end
  end
end
