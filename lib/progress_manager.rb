class ProgressManager
  attr_reader :students

  def initialize(students)
    @students = students
  end

  def run
    input  = ''
    sort   = ''
    name   = ''
    timeline = false
    while input != 'q' do
      system('clear')

      if !name.empty?
        student = @students.select { |x| x.name =~ Regexp.new(name) }
        puts "Overview"; Formatador.display_compact_table(student.map(&:to_hash))
        puts "Timeline"; Formatador.display_compact_table(student.first.assignments.map(&:to_hash))
        puts "Breakdown";Formatador.display_compact_table(student.first.to_hist)
      else
        if timeline
          assignments = @students.map(&:assignments)
          formatted_as = assignments
            .map { |x| x.group_by { |a| a.title } }
            .inject({}) { |a,b| a.merge(b) { |_, x, y| [*x, *y] }}
            .map { |k,v| { k => "[light_green](#{grade = ((v.select(&:complete?).length.to_f / assignments.length.to_f) * 100).round}%)#{' ' if grade < 100} [/][green]#{'#' * v.select(&:complete?).length}[/]"} }
            .map { |k| { completed: k.values.first, title:k.keys.first }}
          Formatador.display_compact_table(formatted_as)
        else
          Formatador.display_compact_table(@students.map(&:to_hash))
        end
      end

      input = display_ui
      name  = ''

      if sort == input
        @students = @students.reverse
      else
        timeline = false
        sort = input
        case sort
        when '#' then timeline = true
        when 'c' then @students = @students.sort_by { |x| x.completed }
        when 'l' then @students = @students.sort_by { |x| x.late }
        when 'n' then @students = @students.sort_by { |x| x.name }
        when 'a' then @students = @students.sort_by { |x| x.absenses }
        when 't' then @students = @students.sort_by { |x| x.tardies }
        when 's' then print 'student > '; name = gets.chomp
        end
      end
    end
  end

  def display_ui
    puts 'Sort by (c)ompleted, (l)ate, (n)ame, (a)bsenses, (t)ardies. filter by (s)tudent [q to quit]'
    print '> '
    gets.chomp
  end


end
