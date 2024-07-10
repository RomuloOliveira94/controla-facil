class Category < ApplicationRecord
  has_many :incomes
  has_many :expenses

  validates :name, presence: true
  validates :cat_sub, presence: true
  validates :icon, presence: true

  before_destroy :disassociate_uses

  def disassociate_uses
    if self.cat_sub === "expenses"
      self.expenses.update_all(category_id: Category.find_by(name: 'Other').id)
    else
      self.incomes.update_all(category_id: Category.find_by(name: 'Other').id)
    end
  end
end
