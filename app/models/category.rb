class Category < ApplicationRecord
  has_one_attached :icon
  has_many :incomes
  has_many :expenses
end
