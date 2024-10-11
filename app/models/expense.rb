class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  before_validation :set_balance

  validates :value, presence: true
  # validates :balance_id, presence: true
  validates :user_id, presence: true
  validates :date, presence: true
  # validate :date_only_on_current_month, on: %i[create update]

  include UpdateBalanceValue

  def self.ransackable_attributes(_auth_object = nil)
    %w[balance_id category_id created_at day description fixed id updated_at
       user_id value]
  end

  def set_balance
    return unless date.present?

    @expense_date = date
    self.balance = user.balances.find_by(month: @expense_date.month, year: @expense_date.year)
    return unless balance.nil?

    generate_new_balance
    self.balance = user.balances.find_by(month: @expense_date.month, year: @expense_date.year)
  end

  def generate_new_balance
    if user.balances.empty?
      user.balances.create(month: @expense_date.month, year: @expense_date.year, balance: 0)
    else
      MonthlyBalanceService.new(user, @expense_date.month, @expense_date.year).generate_monthly_balance
    end
  end

  # def date_only_on_current_month
  #   return if date.blank?

  #   return unless date.month != Time.zone.now.month || date.year != Time.zone.now.year

  #   errors.add(:date,
  #              'Coloque uma data referente ao mês atual')
  # end
end
