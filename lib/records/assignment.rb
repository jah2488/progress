class Assignment < Record
  attr_accessor :title, :info, :opts

  def initialize(title: '', info: '', **opts)
    @title = title
    @info  = info
    @opts  = opts
  end

  def to_h
    {
      title: title,
      info: info
    }
  end

end


