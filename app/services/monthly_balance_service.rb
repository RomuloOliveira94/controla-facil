class MonthlyBalanceService
  def initialize(user, month, year)
    @user = user
    @month = month
    @year = year
  end

  def generate_monthly_balance
    if @user.balances.nil?
      user.balances.create(month: @month, year: @year, balance: 0)
      return
    end

    @last_balance = last_balance
    puts "last_balance: #{@last_balance.inspect}"
    generate_balance_for_current_month
  end

  def generate_balance_for_current_month
    @new_balance = Balance.new(month: @month, year: @year, user: @user, balance: 0)
    return unless @new_balance.save

    save_fixed_expenses
    save_fixed_incomes
    update_balance_value
  end

  def save_fixed_expenses
    last_fixed_expenses = @last_balance.expenses.where(fixed: true)
    return if last_fixed_expenses.empty?

    last_fixed_expenses.each do |expense|
      new_expense = Expense.new(value: expense.value, date: generate_new_date(expense.date), description: expense.description, fixed: true, balance: @new_balance,
                                category: expense.category, user: @user)
      new_expense.save
    end
  end

  def save_fixed_incomes
    last_fixed_incomes = @last_balance.incomes.where(fixed: true)
    return if last_fixed_incomes.empty?

    last_fixed_incomes.each do |income|
      new_income = Income.new(value: income.value, day: income.day, description: income.description, date: generate_new_date(income.date), fixed: true, balance: @new_balance,
                              category: income.category, user: @user)
      new_income.save
    end
  end

  def update_balance_value
    @new_balance.update(balance: @new_balance.incomes.sum(:value) - @new_balance.expenses.sum(:value))
  end

  def last_balance
    generate_time_and_month_values
    @user.balances.includes(:expenses, :incomes).where(month: @last_month,
                                                       year: @last_year).first || @user.balances.last
  end

  def generate_time_and_month_values
    if @month == 1
      @last_month = 12
      @last_year = @year - 1
    else
      @last_month = @month - 1
      @last_year = @year
    end
  end

  def generate_new_date(date)
    return if date.nil?

    date = date.change(day: 28) if @month == 2 && date.day > 28
    date.change(month: @month, year: @year)
  end
end
