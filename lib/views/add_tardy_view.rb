require_relative './add_to_student_view'
class AddTardyView < View
  def attr
    :tardy
  end

  def inc_attr
    :add_tardy
  end
end
