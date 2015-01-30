class Record
  def self.attributes
    self.new.to_h.keys
  end

  def to_json(*)
    self.to_h.merge({ id: @opts[:id] }).to_json
  end
end
