class View

  def initialize(vm, **opts)
    @vm = vm
    @messages = Array.new(5, '')
    opts.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def present
    @messages[-5..-1].map(&method(:puts))
  end

  def prompt
    get
  end

  def action(response)
    case response
    when 'q' then puts 'goodbye'; @vm.back
    end
  end

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
end
