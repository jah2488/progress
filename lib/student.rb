class Student < Struct.new(:name, :absenses, :tardies, :assignments)

  def completed
    assignments.select(&:complete?).length
  end

  def late
    assignments.select(&:late?).length
  end

  def tardies_info
    case tardies
    when 3..8  then "[yellow]#{tardies}[/]"
    when 9..30 then "[red]#{tardies}[/]"
    else
      tardies
    end
  end

  def absenses_info
    case absenses
    when 1..2  then "[yellow]#{absenses}[/]"
    when 3     then "[red]#{absenses}[/]"
    when 4..99 then "[bold][red]#{absenses}[/][/]"
    else
      absenses
    end
  end

  def completed_info
    to_p(:complete?)
  end

  def late_info
    to_p(:late?)
  end

  def to_hist
    [{
      amount: "[green]#{'#' * completed}[/]",
      type: 'complete'
    },
    {
      amount: "[yellow]#{'#' * late}[/]",
      type: 'late'
    },
    {
      amount: "[red]#{'#' * (assignments.length - completed)}[/]",
      type: 'incomplete'
    }]
  end

  def to_hash
    {name: name, absenses: absenses_info, tardies: tardies_info,
     completed: completed_info, late: late_info}
  end

  private

  def to_p(attr)
    amount  = assignments.select(&attr).length
    total   = assignments.length
    percent = ((amount.to_f / total.to_f) * 100).round
    "[#{c(percent, attr)}]#{amount}/#{total} (#{percent}%)[/]"
  end

  def c(n, attr)
    map = {
      'complete?' => {
        :low => 'red', :mid => 'yellow', :top => 'green'
      },
      'late?' => {
        :low => 'green', :mid => 'yellow', :top => 'red'
      }
    }
    case n
    when 0..41   then map[attr.to_s][:low]
    when 42..62  then map[attr.to_s][:mid]
    when 63..100 then map[attr.to_s][:top]
    else
      'white'
    end
  end

end


