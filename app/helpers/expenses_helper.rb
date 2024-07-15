module ExpensesHelper
  def submit_expense_button_text
    @expense.new_record? ? "Gerar novo custo" : "Atualizar custo"
  end
end
