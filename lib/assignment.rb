class Assignment
  attr_accessor :title, :info, :opts

  def initialize(title: '', info: '', **opts)
    @title = title
    @info  = info
    @opts  = opts
  end

  def self.attributes
    self.new.to_h.keys
  end

  def to_h
    {
      title: title,
      info: info
    }
  end

  def to_json(*)
    self.to_h.merge({ id: @opts[:id] }).to_json
  end
end


