module IncomesHelper

  def submit_income_button_text
    @income.new_record? ? "Gerar nova receita" : "Atualizar receita"
  end
end
