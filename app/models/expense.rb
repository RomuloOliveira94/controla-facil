class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  validates :value, presence: true
  validates :user_id, presence: true
  validates :date, presence: true

  include UpdateBalanceValue
  include SetBalance

  def self.ransackable_attributes(_auth_object = nil)
    %w[balance_id category_id created_at day description fixed id updated_at
       user_id value date]
  end
end
