# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Categorias fixas (globais, sem dono).
#
# A identidade de uma categoria fixa é o par (name, cat_sub) — é o que a
# aplicação usa para distinguir, por exemplo, "Outras" de despesa e "Outras" de
# receita. O find_or_create_by! casa por esse par mais fixed: true, e os demais
# atributos são atribuídos apenas na criação.
#
# O fixed: true no matcher importa porque usuários criam as próprias categorias:
# sem ele, uma categoria de usuário chamada "Alimentação" de despesa seria
# encontrada pela busca e impediria a criação da categoria global de mesmo nome.
#
# Isso importa no primeiro boot depois da migração para SQLite: a criação do
# banco da fila faz o db:prepare rodar os seeds, com o banco primário já
# populado pela cópia. Se o matcher incluísse description e icon, qualquer
# diferença nesses textos criaria uma segunda categoria fixa com o mesmo nome,
# em silêncio, e os usuários passariam a ver a categoria duplicada.
fixed_categories = [
  # despesas
  { name: 'Alimentação',   cat_sub: 'expenses', description: 'Despesas relacionadas a alimentação',    icon: 'fas fa-utensils' },
  { name: 'Transporte',    cat_sub: 'expenses', description: 'Despesas relacionadas a Transporte',     icon: 'fas fa-bus' },
  { name: 'Saúde',         cat_sub: 'expenses', description: 'Despesas relacionadas a saúde',          icon: 'fas fa-medkit' },
  { name: 'Entertainment', cat_sub: 'expenses', description: 'Despesas relacionadas a Entretenimento', icon: 'fas fa-film' },
  { name: 'Education',     cat_sub: 'expenses', description: 'Despesas relacionadas Educação',         icon: 'fas fa-graduation-cap' },
  { name: 'Outras',        cat_sub: 'expenses', description: 'Outras despesas',                        icon: 'fas fa-question-circle' },
  { name: 'Moradia',       cat_sub: 'expenses', description: 'Despesas relacionadas',                  icon: 'fas fa-home' },
  # receitas
  { name: 'Salário',       cat_sub: 'incomes',  description: 'Receitas de Salário',                    icon: 'fas fa-money-bill-wave' },
  { name: 'Investimentos', cat_sub: 'incomes',  description: 'Receitas de Investimentos',              icon: 'fas fa-chart-line' },
  { name: 'Presente',      cat_sub: 'incomes',  description: 'Receitas recebidas como presente',       icon: 'fas fa-gift' },
  { name: 'Outras',        cat_sub: 'incomes',  description: 'Outras receitas',                        icon: 'fas fa-question-circle' }
]

fixed_categories.each do |attributes|
  Category.find_or_create_by!(name: attributes[:name], cat_sub: attributes[:cat_sub], fixed: true) do |category|
    category.description = attributes[:description]
    category.icon = attributes[:icon]
  end
end
