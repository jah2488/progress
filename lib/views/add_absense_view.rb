require_relative './add_to_student_view'
class AddAbsenseView < AddToStudentView
  def attr
    :absenses
  end

  def inc_attr
    :add_absense
  end
end
