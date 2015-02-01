require_relative './add_to_student_view'
class AddTardyView < AddToStudentView
  def attr
    :tardies
  end

  def inc_attr
    :add_tardy
  end
end
