class Income < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  before_validation :set_balance

  validates :value, presence: true
  validates :day, presence: true, if: :fixed?
  validates :date, presence: true

  before_update :clear_day_if_not_fixed

  after_save :update_balance_value

  include UpdateBalanceValue
  include SetBalance

  def self.ransackable_attributes(_auth_object = nil)
    %w[balance_id category_id created_at day description fixed id updated_at
       user_id value]
  end

  def income_month_year
    created_at.strftime('%B/%Y')
  end

  private

  def clear_day_if_not_fixed
    self.day = nil unless fixed?
  end
end
