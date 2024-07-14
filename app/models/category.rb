class Category < ApplicationRecord
  has_many :incomes
  has_many :expenses
  belongs_to :user

  validates :name, presence: true
  validates :cat_sub, presence: true
  validates :icon, presence: true

  before_destroy :disassociate_uses
  before_create :check_user_category_limit

  scope :user_global, ->(user) { where('user_id IS NULL OR user_id = ?', user.id) }
  scope :incomes, -> { where(cat_sub: 'incomes').order(:created_at) }
  scope :expenses, -> { where(cat_sub: 'expenses').order(:created_at) }

  def disassociate_uses
    if cat_sub === 'expenses'
      expenses.update_all(category_id: Category.find_by(name: 'Other').id)
    else
      incomes.update_all(category_id: Category.find_by(name: 'Other').id)
    end
  end

  def check_user_category_limit
    puts "Checking user category limit for user #{user.id}"
    puts "User has #{user.categories.where(cat_sub:).count} categories"
    return unless user.categories.where(cat_sub:).count >= 10

    errors.add(:base, 'Você atingiu o limite de categorias, exclua alguma para adicionar novas.')
    throw :abort
  end
end
