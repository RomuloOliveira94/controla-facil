module DashboardHelper
  def positive_check(number)
    number.positive? ? 'from-green-400 to-green-600' : 'from-red-400 to-red-600'
  end

  def positive_bool(number)
    number.positive? ? true : false
  end
end
