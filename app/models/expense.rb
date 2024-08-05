class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  validates :value, presence: true
  validates :balance_id, presence: true
  validates :user_id, presence: true
  validates :date, presence: true
  validate :date_only_on_current_month, on: [:create, :update]

  include UpdateBalanceValue

  def self.ransackable_attributes(_auth_object = nil)
    %w[balance_id category_id created_at day description fixed id updated_at
       user_id value]
  end

  def date_only_on_current_month
    errors.add(:date, 'deve ser do mês corrente') unless date.month == Time.zone.today.month
  end
end
