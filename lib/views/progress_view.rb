class ProgressView < View
  def present
      @name ||= ''
      if !@name.empty? && (student = @students.select { |x| x.name.downcase =~ Regexp.new(@name.downcase) }).length > 0
        puts 'Overview'; Formatador.display_compact_table(student.map(&:to_hash))
        puts 'Timeline'; Formatador.display_compact_table(student.first.submissions.map(&:to_hash))
        puts 'Breakdown';Formatador.display_compact_table(student.first.to_hist)
      else
        if @timeline
          Formatador.display_compact_table(assignment_completion_timeline)
        else
          Formatador.display_compact_table(@students.map(&:to_hash))
        end
      end
    puts 'Sort by (c)ompleted, (l)ate, (n)ame, (a)bsenses, (t)ardies. filter by (s)tudent [q to quit, # view completion by assignment]'
  end

  def action(response)
    if @sort == response
      @students = @students.reverse
    else
      @name = ''
      @timeline = false
      @sort = response
      case response
      when '#' then @timeline = true
      when 'c' then @students = @students.sort_by { |x| x.completed }
      when 'l' then @students = @students.sort_by { |x| x.late }
      when 'n' then @students = @students.sort_by { |x| x.name }
      when 'a' then @students = @students.sort_by { |x| x.absenses }
      when 't' then @students = @students.sort_by { |x| x.tardies }
      when 's' then print 'student > '; @name = gets.chomp
      else
        super(response)
      end
    end
  end

  def assignment_completion_timeline
    assignments = @students.map(&:submissions)

    title_hash        = -> (a)    { a.to_hash[:title] }
    group_by_title    = -> (x)    { x.group_by(&title_hash) }
    remove_duplicates = -> (a, b) { a.merge(b) { |_, x, y| [*x, *y] } }
    display_progress  = -> ((k, v)) do
      assn_count = assignments.length
      late_count = v.select(&:late).length
      comp_count = v.select(&:complete).length
      grade    = ((comp_count.to_f / assn_count.to_f) * 100).round
      late     = "[yellow]#{'#' * late_count}[/]"
      complete = "[green]#{'#'  * (comp_count - late_count)}[/]"
      {
        k => "[light_green](#{grade}%)#{' ' if grade < 100} [/]#{late + complete}"
      }
    end
    to_table = -> (k) do
      { :"late / completed" => k.values.first, :title => k.keys.first }
    end

    assignments
      .map(&group_by_title)
      .inject({}, &remove_duplicates)
      .map(&display_progress)
      .map(&to_table)
  end
end
