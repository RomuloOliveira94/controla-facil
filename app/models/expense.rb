class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  validates :value, presence: true
  validates :balance_id, presence: true
  validates :user_id, presence: true
  validates :date, presence: true
end
