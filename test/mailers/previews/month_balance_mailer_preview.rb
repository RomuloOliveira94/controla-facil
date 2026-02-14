require 'ostruct'

class MonthBalanceMailerPreview < ActionMailer::Preview
  def month_balance_email
    user = mock_user
    balance = mock_balance
    total_incomes = balance.incomes.sum(&:value)
    total_expenses = balance.expenses.sum(&:value)

    MonthBalanceMailer.with(user:, balance:, total_incomes:, total_expenses:).month_balance_email
  end

  private

  def mock_user
    OpenStruct.new(
      id: 1,
      first_name: 'João',
      last_name: 'Silva',
      email: 'joao@exemplo.com'
    )
  end

  def mock_balance
    incomes = [
      mock_income('Salário', 5_250.00, '2026-02-05'),
      mock_income('Freelance design', 1_800.00, '2026-02-12'),
      mock_income('Rendimento CDB', 187.45, '2026-02-01'),
      mock_income('Venda notebook usado', 2_300.00, '2026-02-08')
    ]

    expenses = [
      mock_expense('Aluguel', 1_850.00, '2026-02-01'),
      mock_expense('Supermercado Extra', 742.38, '2026-02-03'),
      mock_expense('Conta de luz', 218.90, '2026-02-05'),
      mock_expense('Internet fibra', 119.90, '2026-02-07'),
      mock_expense('Plano de saúde', 489.00, '2026-02-10'),
      mock_expense('Gasolina', 320.00, '2026-02-11'),
      mock_expense('Farmácia', 156.75, '2026-02-13'),
      mock_expense('Restaurante', 187.50, '2026-02-14'),
      mock_expense('Assinatura streaming', 55.90, '2026-02-06'),
      mock_expense('Manutenção carro', 680.00, '2026-02-09')
    ]

    total_incomes = incomes.sum(&:value)
    total_expenses = expenses.sum(&:value)

    OpenStruct.new(
      month: 2,
      year: 2026,
      balance: total_incomes - total_expenses,
      incomes: incomes,
      expenses: expenses
    )
  end

  def mock_income(description, value, date_str)
    OpenStruct.new(
      description: description,
      value: value,
      created_at: Date.parse(date_str)
    )
  end

  def mock_expense(description, value, date_str)
    OpenStruct.new(
      description: description,
      value: value,
      created_at: Date.parse(date_str)
    )
  end
end
