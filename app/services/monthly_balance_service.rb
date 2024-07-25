class MonthlyBalanceService
  def initialize(user)
    @user = user
  end

  def generate_monthly_balance
    generate_time_and_month_values
    @last_balance = @user.balances.includes(:expenses, :incomes).where(month: @month, year: @year).first
    check_if_user_has_some_balance if @last_balance.nil?
    generate_balance_for_current_month
  end

  def generate_balance_for_current_month
    @new_balance = Balance.new(month: Time.now.mon, year: Time.now.year, user: @user, balance: 0)
    return unless @new_balance.save

    save_fixed_expenses
    save_fixed_incomes
  end

  def check_if_user_has_some_balance
    if @user.balances.empty?
      create_balance
      return
    end

    @last_balance = @user.balances.last
  end

  def create_balance
    @balance = Balance.new
    @balance.balance = 0
    @balance.month = Time.now.mon
    @balance.year = Time.now.year
    @balance.user = @user
    @balance.save
  end

  def generate_time_and_month_values
    if Time.now.mon == 1
      @month = 12
      @year = Time.now.year - 1
    else
      @month = Time.now.mon - 1
      @year = Time.now.year
    end
  end

  def save_fixed_expenses
    last_fixed_expenses = @last_balance.expenses.where(fixed: true)
    last_fixed_expenses.each do |expense|
      new_expense = Expense.new(value: expense.value, date: expense.date, description: expense.description, fixed: true, balance: @new_balance,
                                category: expense.category, user: @user)
      puts new_expense
      new_expense.save
    end
  end

  def save_fixed_incomes
    last_fixed_incomes = @last_balance.incomes.where(fixed: true)
    last_fixed_incomes.each do |income|
      new_income = Income.new(value: income.value, day: income.day, description: income.description, fixed: true, balance: @new_balance,
                              category: income.category, user: @user)
      new_income.save
    end
  end
end
