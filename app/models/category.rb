class Category < ApplicationRecord
  has_many :incomes
  has_many :expenses
  belongs_to :user

  validates :name, presence: true
  validates :cat_sub, presence: true
  validates :icon, presence: true

  before_destroy :disassociate_uses

  scope :user_global, ->(user) { where("user_id IS NULL OR user_id = ?", user.id) }
  scope :incomes, -> { where(cat_sub: 'incomes').order(:created_at) }
  scope :expenses, -> { where(cat_sub: 'expenses').order(:created_at) }

  def disassociate_uses
    if self.cat_sub === "expenses"
      self.expenses.update_all(category_id: Category.find_by(name: 'Other').id)
    else
      self.incomes.update_all(category_id: Category.find_by(name: 'Other').id)
    end
  end
end
