class View
  def initialize(vm, **opts)
    @vm = vm
    @messages = Array.new(5, '')
    set_opts(**opts)
  end

  def navigate(view, **kwargs)
    @vm.navigate(view, **kwargs)
  end

  def present
    @messages[-5..-1].map(&method(:puts))
  end

  def prompt
    get
  end

  def say(*args)
    args.each(&@messages.method(:push))
  end

  def action(response)
    case response
    when 'q' then @vm.back
    else
      puts 'invalid'
    end
  end

  protected

  def get(prompt = '>', default = '')
    print Formatador.parse(prompt) + ' '
    print Formatador.parse("[[light_cyan]#{default}[/]] ") unless default.empty?
    response = gets.chomp
    if response.empty?
      default
    else
      response
    end
  end

  private

  def set_opts(**opts)
    opts.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end
end

