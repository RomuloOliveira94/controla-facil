require 'test_helper'

# Canário de precisão decimal: value/balance são decimal(10,2) no MySQL e o
# adapter devolve BigDecimal. O SQLite não tem tipo decimal nativo, então este
# teste trava a aritmética exata que a aplicação depende hoje.
class BalanceMathTest < ActiveSupport::TestCase
  setup do
    @user = create_user
    @date = Date.new(2026, 3, 15)
    @balance = @user.balances.create!(month: @date.month, year: @date.year, balance: 0)
    @income_category = create_category(name: 'Salário', cat_sub: 'incomes', fixed: true)
    @expense_category = create_category(name: 'Alimentação', cat_sub: 'expenses', fixed: true)
  end

  test 'armazena valores monetários como BigDecimal' do
    income = create_income('10.10')

    assert_instance_of BigDecimal, income.reload.value
    assert_equal BigDecimal('10.10'), income.value
  end

  test 'soma valores decimais sem erro de ponto flutuante' do
    create_income('10.10')
    create_income('0.20')
    create_income('1234.56')

    assert_equal BigDecimal('1244.86'), @balance.incomes.sum(:value)
  end

  test 'recalcula o saldo com aritmética decimal exata' do
    create_income('10.10')
    create_income('0.20')
    create_income('1234.56')
    create_expense('44.86')

    assert_equal BigDecimal('1200.00'), @balance.reload.balance
    assert_instance_of BigDecimal, @balance.balance
  end

  test 'recalcula o saldo ao remover uma despesa' do
    create_income('10.10')
    expense = create_expense('0.20')

    assert_equal BigDecimal('9.90'), @balance.reload.balance

    expense.destroy!

    assert_equal BigDecimal('10.10'), @balance.reload.balance
  end

  test 'mantém saldo negativo exato quando as despesas superam as receitas' do
    create_income('0.10')
    create_expense('1234.56')

    assert_equal BigDecimal('-1234.46'), @balance.reload.balance
  end

  private

  def create_income(value)
    @user.incomes.create!(value: BigDecimal(value), date: @date, category: @income_category,
                          description: "receita #{value}")
  end

  def create_expense(value)
    @user.expenses.create!(value: BigDecimal(value), date: @date, category: @expense_category,
                           description: "despesa #{value}")
  end
end
