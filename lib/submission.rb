class Submission
  attr_accessor :title, :late, :complete, :opts

  def initialize(title: '', late: false, complete: true, **opts)
    @title, @late, @complete, @opts = *[title, late, complete, opts]
  end

  def self.attributes
    Submission.new.to_h.keys
  end

  def to_hash
    {
      title: REPO[:assignments].find { |x| x.opts[:id] == title }.title,
      progress: progress_info
    }
  end

  def progress_info
    return "[green]########[/]"  if complete
    return "[yellow]####[/]" if !complete && !late
    return "[red]#[/]" if !complete
    return "[yellow]##[/]" if late
  end

  def to_h
    {
      title: title,
      late: late,
      complete: complete
    }
  end

  def to_json(*)
    self.to_h.merge({ id: @opts[:id] }).to_json
  end
end

