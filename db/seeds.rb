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

Category.find_or_create_by!(name: 'Food', description: 'All expenses related to food', cat_sub: 1, fixed: true, icon: 'fas fa-utensils')
Category.find_or_create_by!(name: 'Transport', description: 'All expenses related to transport', cat_sub: 1, fixed: true, icon: 'fas fa-bus')
Category.find_or_create_by!(name: 'Health', description: 'All expenses related to health', cat_sub: 1, fixed: true, icon: 'fas fa-medkit')
Category.find_or_create_by!(name: 'Entertainment', description: 'All expenses related to entertainment', cat_sub: 1, fixed: true, icon: 'fas fa-film')
Category.find_or_create_by!(name: 'Education', description: 'All expenses related to education', cat_sub: 1, fixed: true, icon: 'fas fa-graduation-cap')
Category.find_or_create_by!(name: 'Other', description: 'All other expenses', cat_sub: 1, fixed: true, icon: 'fas fa-question-circle')

#create incomes categories

Category.find_or_create_by!(name: 'Salary', description: 'All incomes related to salary', cat_sub: 2, fixed: true, icon: 'fas fa-money-bill-wave')
Category.find_or_create_by!(name: 'Investment', description: 'All incomes related to investment', cat_sub: 2, fixed: true, icon: 'fas fa-chart-line')
Category.find_or_create_by!(name: 'Gift', description: 'All incomes related to gift', cat_sub: 2, fixed: true, icon: 'fas fa-gift')
Category.find_or_create_by!(name: 'Other', description: 'All other incomes', cat_sub: 2, fixed: true, icon: 'fas fa-question-circle')
