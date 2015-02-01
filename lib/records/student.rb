class Student < Record
  attr_accessor :name, :absenses, :tardies, :submissions, :opts

  def initialize(name: '', absenses: 0, tardies: 0, submissions: [], **opts)
    @name = name
    @absenses = absenses
    @tardies = tardies
    @submissions = submissions.map { |s| Submission.new(Hash[s.map { |k,v| [k.to_sym, v]}]) } #move to submission
    @opts = opts
  end

  def completed
    submissions.select(&:complete).length
  end

  def late
    submissions.select(&:late).length
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

  def add_absense
    @absenses = (@absenses.to_i.succ).to_s
  end

  def add_tardy
    @tardies = (@tardies.to_i.succ).to_s
  end

  def add_submission(submission)
    if submissions.map { |x| x.title }.include?(submission.title)
      puts 'duplicate detected'
    else
      submissions << submission
    end
  end

  def completed_info
    to_p(:complete)
  end

  def late_info
    to_p(:late)
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
      amount: "[red]#{'#' * (submissions.length - completed)}[/]",
      type: 'incomplete'
    }]
  end

  def to_hash
    {name: name, absenses: absenses_info, tardies: tardies_info,
     completed: completed_info, late: late_info}
  end

  def to_h
    {
      name: name,
      absenses: absenses,
      tardies: tardies,
      submissions: submissions.map(&:to_h)
    }
  end

  def to_s
    name
  end

  private

  def to_p(attr)
    amount  = submissions.select(&attr).length
    total   = REPO[:assignments].length
    if total.zero?
      percent = 100
    else
      percent = ((amount.to_f / total.to_f) * 100).round
    end
    "[#{c(percent, attr)}]#{amount}/#{total} (#{percent}%)[/]"
  end

  def c(n, attr)
    map = {
      'complete' => {
        :low => 'red', :mid => 'yellow', :top => 'green'
      },
      'late' => {
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
