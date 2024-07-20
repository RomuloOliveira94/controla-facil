class Income < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  belongs_to :category

  validates :value, presence: true
  validates :day, presence: true, if: :fixed?

  before_update :clear_day_if_not_fixed

  private

  def clear_day_if_not_fixed
    self.day = nil unless fixed?
  end
end
