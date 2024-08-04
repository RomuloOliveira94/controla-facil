class Balance < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :destroy
  has_many :incomes, dependent: :destroy

  def all_incomes_and_expenses
    incomes + expenses
  end
end
