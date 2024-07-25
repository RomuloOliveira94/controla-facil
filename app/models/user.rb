class User < ApplicationRecord
  include ReviseAuth::Model
  has_one_attached :avatar
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :balances, dependent: :destroy
  has_many :categories, dependent: :destroy

  def self.generate_monthly_balance
    User.all.each do |user|
      user.generate_balance_for_current_month
    end
  end

  def generate_balance_for_current_month
    last_balance = balances.includes(:expenses, :incomes).where(month: Time.now.mon, year: Time.now.year).first

    puts "last_balance: #{last_balance}"

    return if last_balance.nil?

    last_fixed_expenses = last_balance.expenses.where(fixed: true)
    last_fixed_incomes = last_balance.incomes.where(fixed: true)

    new_balance = Balance.new(month: Time.now.mon, year: Time.now.year, user: self)

    return unless new_balance.save

    puts 'rodou aqui'

    last_fixed_expenses.each do |expense|
      new_expense = Expense.new(value: expense.value, date: expense.date, description: expense.description, fixed: true, balance: new_balance,
                                category: expense.category, user: self)
      new_expense.save
    end

    last_fixed_incomes.each do |income|
      new_income = Income.new(value: income.value, day: income.day, description: income.description, fixed: true, balance: new_balance,
                              category: income.category, user: self)
      new_income.save
    end
  end
end
