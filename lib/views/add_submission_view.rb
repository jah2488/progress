class AddSubmissionView < View

  def initialize(vm, **opts)
    super(vm, **opts)

    @submission   = {}
    @steps = [
      {
        present: -> {
          puts 'Add Submission for which student?'
          @avail_students = @students.reject { |s| s.submissions.length >= REPO[:assignments].length }
          @avail_students.each_with_index do |student, index|
            puts "#{index}) #{student.name}"
          end
        },
        action: -> response {
          case response
          when '0'..@avail_students.length.to_s
            @student = @avail_students[response.to_i]
          else
            super(response)
          end
        }
      },
      {
        present: -> {
          puts "Which assignment for #@student?"
          @filtered = @assignments.reject { |a| @student.submissions.any? { |s| s.title == a.opts[:id] } }
          @filtered.each_with_index do |assignment, index|
            puts "#{index}) #{assignment.title}"
          end
        },
        action: -> response {
          case response
          when '0'..@filtered.length.to_s
            @assignment = @filtered[response.to_i]
          else
            super(response)
          end
        }
      },
      {
        present: -> {
          puts "Which assignment for #@student?"
        },
        prompt: -> {
          @is_late     = get('< late (y/[light_cyan]n[/]) >', 'n')
          @is_complete = get('< complete ([light_cyan]y[/]/n) >', 'y')
        },
        action: -> response {
          @submission[:late] = !!(@is_late =~ /y/)
          @submission[:complete] = !!(@is_complete =~ /y/)
          @submission[:title] = @assignment.opts[:id]
          on_confirm = -> do
            @student.add_submission(Submission.new(@submission))
            REPO.update(:students, @student)
            @vm.back
          end
          @vm.navigate(ConfirmView,
                       on_present: -> { puts @submission.to_h },
                       on_confirm: on_confirm)
        }
      }
    ]
    @step_enum = @steps.each
    @current_step = @step_enum.next
  end

  def present
    puts 'Add New Homework Submission'
    @current_step.fetch(:present).call
  end

  def prompt
    pr = @current_step[:prompt]
    if pr
      pr.call
    else
      super
    end
  end

  def action(response)
    @current_step.fetch(:action).call(response)
    @current_step = @step_enum.next
  rescue StopIteration => _
    puts 'end of iteration'
  end
end
