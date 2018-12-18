require "administrate/field/base"

class MethodField < Administrate::Field::Base
  def to_s
    data
  end
end
