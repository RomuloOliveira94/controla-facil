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

Category.find_or_create_by!(name: 'Alimentação', description: 'Despesas relacionadas a alimentação', cat_sub: 1, fixed: true, icon: 'fas fa-utensils')
Category.find_or_create_by!(name: 'Transporte', description: 'Despesas relacionadas a Transporte', cat_sub: 1, fixed: true, icon: 'fas fa-bus')
Category.find_or_create_by!(name: 'Saúde', description: 'Despesas relacionadas a saúde', cat_sub: 1, fixed: true, icon: 'fas fa-medkit')
Category.find_or_create_by!(name: 'Entertainment', description: 'Despesas relacionadas a Entretenimento', cat_sub: 1, fixed: true, icon: 'fas fa-film')
Category.find_or_create_by!(name: 'Education', description: 'Despesas relacionadas Educação', cat_sub: 1, fixed: true, icon: 'fas fa-graduation-cap')
Category.find_or_create_by!(name: 'Other', description: 'Outras despesas', cat_sub: 1, fixed: true, icon: 'fas fa-question-circle')
Category.find_or_create_by!(name: 'Moradia', description: 'Despesas relacionadas', cat_sub: 1, fixed: true, icon: 'fas fa-home')

#create incomes categories

Category.find_or_create_by!(name: 'Salário', description: 'Receitas de Salário', cat_sub: 2, fixed: true, icon: 'fas fa-money-bill-wave')
Category.find_or_create_by!(name: 'Investimentos', description: 'Receitas de Investimentos', cat_sub: 2, fixed: true, icon: 'fas fa-chart-line')
Category.find_or_create_by!(name: 'Presente', description: 'Receitas recebidas como presente', cat_sub: 2, fixed: true, icon: 'fas fa-gift')
Category.find_or_create_by!(name: 'Outras', description: 'Outras receitas', cat_sub: 2, fixed: true, icon: 'fas fa-question-circle')
