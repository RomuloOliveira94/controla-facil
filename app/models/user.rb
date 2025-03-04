class User < ApplicationRecord
  include ReviseAuth::Model
  has_one_attached :avatar
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :balances, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_one :push_subscription, dependent: :destroy
end
