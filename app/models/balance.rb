class Balance < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :destroy
  has_many :incomes, dependent: :destroy

  def all_incomes_and_expenses
    incomes.includes(:category) + expenses.includes(:category)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[balance created_at green id id_value month red updated_at user_id year]
  end
end
