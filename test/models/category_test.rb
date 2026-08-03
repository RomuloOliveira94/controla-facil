require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @user = create_user
    @other_user = create_user(email: 'outro@example.com')

    @fixed_expense = create_category(name: 'Alimentação', cat_sub: 'expenses', fixed: true)
    @fixed_income = create_category(name: 'Salário', cat_sub: 'incomes', fixed: true)
    @own_expense = create_category(name: 'Pets', cat_sub: 'expenses', user: @user)
    @own_income = create_category(name: 'Freelas', cat_sub: 'incomes', user: @user)
    @other_expense = create_category(name: 'Hobbies', cat_sub: 'expenses', user: @other_user)
  end

  test 'persiste cat_sub como string' do
    assert_instance_of String, @fixed_expense.reload.cat_sub
    assert_equal 'expenses', @fixed_expense.cat_sub
    assert_equal 'incomes', @fixed_income.reload.cat_sub
  end

  test 'rejeita cat_sub fora dos valores permitidos' do
    category = Category.new(name: 'Inválida', cat_sub: 'outros', icon: 'fas fa-question-circle')

    assert_predicate category, :invalid?
    assert_includes category.errors.attribute_names, :cat_sub
  end

  test 'rejeita cat_sub numérico herdado do ENUM' do
    category = Category.new(name: 'Inválida', cat_sub: 1, icon: 'fas fa-question-circle')

    assert_predicate category, :invalid?
    assert_includes category.errors.attribute_names, :cat_sub
  end

  test 'rejeita cat_sub em branco' do
    assert_predicate Category.new(name: 'Inválida', icon: 'fas fa-question-circle'), :invalid?
  end

  test 'scope expenses retorna apenas categorias de despesa' do
    expenses = Category.expenses

    assert_includes expenses, @fixed_expense
    assert_includes expenses, @own_expense
    assert_includes expenses, @other_expense
    assert_not_includes expenses, @fixed_income
    assert_not_includes expenses, @own_income
    assert_equal ['expenses'], expenses.pluck(:cat_sub).uniq
  end

  test 'scope incomes retorna apenas categorias de receita' do
    incomes = Category.incomes

    assert_includes incomes, @fixed_income
    assert_includes incomes, @own_income
    assert_not_includes incomes, @fixed_expense
    assert_not_includes incomes, @own_expense
    assert_equal ['incomes'], incomes.pluck(:cat_sub).uniq
  end

  test 'scope user_global retorna categorias fixas e do próprio usuário' do
    scoped = Category.user_global(@user)

    assert_includes scoped, @fixed_expense
    assert_includes scoped, @fixed_income
    assert_includes scoped, @own_expense
    assert_includes scoped, @own_income
    assert_not_includes scoped, @other_expense
  end

  test 'scope user_global combina com os scopes de tipo' do
    scoped = Category.user_global(@user).expenses

    assert_includes scoped, @fixed_expense
    assert_includes scoped, @own_expense
    assert_not_includes scoped, @fixed_income
    assert_not_includes scoped, @other_expense
  end
end
