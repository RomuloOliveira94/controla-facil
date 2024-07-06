# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



#create expenses categories

Category.find_or_create_by!(name: 'Food', description: 'All expenses related to food')
Category.find_or_create_by!(name: 'Transport', description: 'All expenses related to transport')
Category.find_or_create_by!(name: 'Health', description: 'All expenses related to health')
Category.find_or_create_by!(name: 'Entertainment', description: 'All expenses related to entertainment')
Category.find_or_create_by!(name: 'Education', description: 'All expenses related to education')
Category.find_or_create_by!(name: 'Other', description: 'All other expenses')

#create incomes categories

Category.find_or_create_by!(name: 'Salary', description: 'All incomes related to salary')
Category.find_or_create_by!(name: 'Investment', description: 'All incomes related to investment')
Category.find_or_create_by!(name: 'Gift', description: 'All incomes related to gift')
Category.find_or_create_by!(name: 'Other', description: 'All other incomes')

