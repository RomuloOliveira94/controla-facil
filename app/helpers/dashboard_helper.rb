module DashboardHelper
  def positive_check(number)
    number.positive? ? 'bg-success' : 'bg-error'
  end

  def positive_bool(number)
    number.positive? ? true : false
  end
end
