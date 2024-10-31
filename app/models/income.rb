class Income < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  before_validation :set_balance

  validates :value, presence: true
  # validates :day, presence: true, if: :fixed?
  validates :date, presence: true
  
  after_save :update_balance_value

  include UpdateBalanceValue
  include SetBalance

  def self.ransackable_attributes(_auth_object = nil)
    %w[balance_id category_id created_at day description fixed id updated_at
       user_id value date]
  end

  def income_month_year
    created_at.strftime('%B/%Y')
  end
end
