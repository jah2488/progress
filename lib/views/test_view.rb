class TestView < View
  def present
    puts 'I am a test view'
    puts 'press any key to quit'
    super
  end
  def prompt
    get('< which key? >', '@')
  end
  def action(response)
    if response == '@'
      @messages << 'not that one'
    else
      super(response)
    end
  end
end

