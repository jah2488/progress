class Assignment < Struct.new(:title, :late?, :complete?)
  def to_hash
    {
      title: title,
      progress: progress_info
    }
  end

  def progress_info
    return "[green]########[/]"  if complete?
    return "[yellow]####[/]" if !complete? && !late?
    return "[red]#[/]" if !complete?
    return "[yellow]##[/]" if late?
  end
end


