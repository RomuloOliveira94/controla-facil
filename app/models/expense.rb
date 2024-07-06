class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

end
