class User < ApplicationRecord
  include ReviseAuth::Model
  has_one_attached :avatar
end
