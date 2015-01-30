class ProgressView < View
  def present
      @name ||= ''
      if !@name.empty? && (student = @students.select { |x| x.name.downcase =~ Regexp.new(@name.downcase) }).length > 0
        puts 'Overview'; Formatador.display_compact_table(student.map(&:to_hash))
        puts 'Timeline'; Formatador.display_compact_table(student.first.submissions.map(&:to_hash))
        puts 'Breakdown';Formatador.display_compact_table(student.first.to_hist)
      else
        if @timeline
          #yay pipelining!
          #omg the horror of this method chaining mess
          assignments = @students.map(&:submissions)
          formatted_as = assignments
            .map { |x| x.group_by { |a| a.to_hash[:title] } }
            .inject({}) { |a,b| a.merge(b) { |_, x, y| [*x, *y] }}
            .map { |k,v| { k => "[light_green](#{grade = ((v.select(&:complete).length.to_f / assignments.length.to_f) * 100).round}%)#{' ' if grade < 100} [/][green]#{'#' * v.select(&:complete).length}[/]"} }
            .map { |k| { completed: k.values.first, title:k.keys.first }}
          Formatador.display_compact_table(formatted_as)
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
end
