class ProgressManager
  attr_reader :students, :assignments

  def initialize(students, assignments)
    @students = students
    @assignments = assignments
  end

  def run
    menu_view
  end

  def get(prompt = '>')
    print prompt + ' '
    response = gets.chomp
    if response == 'q'
      #menu_view <- cant quit when on menu_view need to implement 'view stack'
    end
    response
  end

  def menu_view
    ui_loop do |input|
      puts '---- Student and Assignment progress tracker ----'
      puts 'Add (s)tudent, (a)ssignment, add s(u)bmission [p to progress, q to quit, ! to debug]'

      input = get

      case input
      when 'p' then progress_view
      when 'h' then puts 'help!'
      when 's' then add_student_view
      when 'u' then add_submission_view
      when 'a' then add_assignment_view
      when 'q' then puts 'goodbye'; exit
      when '!' then require 'pry'; binding.pry
      end

      input
    end
  end

  def add_assignment_view
    assignment ||= {}
    ui_loop do |input|
      puts 'Add Assignment'
      Assignment.attributes.each do |attr|
        puts assignment[attr]
        assignment[attr] = get("< #{attr} >")
      end
      break
    end
    REPO.save(:assignments, assignment)
  end

  def add_student_view
    student ||= {}
    ui_loop do |input|
      puts 'Add Student'
      Student.attributes.each do |attr|
        next if attr == :submissions
        puts student[attr]
        student[attr] = get("< #{attr} >")
      end
      break
    end
    REPO.save(:students, student)
  end

  def add_submission_view
    # submissions should really be a 'join table' this (now legacy) nested thing isn't working out.
    student_record = nil
    ui_loop do |input|

      puts 'Add Submission to which student?'
      avail_students = students.reject { |s| s.submissions.length >= REPO[:assignments].length }
      avail_students.each_with_index do |student, index|
        puts "#{index}) #{student.name}"
      end
      student_record = avail_students[get.to_i]

      puts 'Which assignment?'
      filtered = assignments.reject { |a| student_record.submissions.any? { |s| s.title == a.opts[:id] } }
      filtered.each_with_index do |assignment, index|
        puts "#{index}) #{assignment.title}"
      end
      assignment = filtered[get.to_i]

      submission = Submission.new(title: assignment.opts[:id])
      is_late = get('< late (y/n) >')
      is_complete = get('< complete (y/n) >')
      submission.late = !!(is_late =~ /[y|yes|true|1]/)
      submission.complete = !!(is_complete =~ /[y|yes|true|1]/)

      student_record.add_submission(submission)

      puts student_record.name
      puts assignment.title
      puts submission.to_h
      if !!(get('< Is correct? >') =~ /[y|yes|true|1]/)
        break
      end
    end
    REPO.update(:students, student_record)
  end

  def progress_view
    input  = ''
    sort   = ''
    name   = ''
    timeline = false
    while input != 'q' do
      system('clear')

      if !name.empty? && (student = @students.select { |x| x.name.downcase =~ Regexp.new(name.downcase) }).length > 0
        puts "Overview"; Formatador.display_compact_table(student.map(&:to_hash))
        puts "Timeline"; Formatador.display_compact_table(student.first.submissions.map(&:to_hash))
        puts "Breakdown";Formatador.display_compact_table(student.first.to_hist)
      else
        if timeline
          assignments = @students.map(&:submissions)
          formatted_as = assignments
            .map { |x| x.group_by { |a| a.title } }
            .inject({}) { |a,b| a.merge(b) { |_, x, y| [*x, *y] }}
            .map { |k,v| { k => "[light_green](#{grade = ((v.select(&:complete).length.to_f / assignments.length.to_f) * 100).round}%)#{' ' if grade < 100} [/][green]#{'#' * v.select(&:complete).length}[/]"} }
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

  private
  def ui_loop(&block)
    loop do
      system('clear')
      block.call('')
    end
  end

end
