class Income < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  validates :value, presence: true
  validates :description, presence: true
  validates :category_id, presence: true
  validates :balance_id, presence: true
end
