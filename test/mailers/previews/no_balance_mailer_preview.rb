require 'ostruct'

class NoBalanceMailerPreview < ActionMailer::Preview
  def no_balance_mail
    user = OpenStruct.new(
      id: 1,
      first_name: 'João',
      last_name: 'Silva',
      email: 'joao@exemplo.com'
    )

    NoBalanceMailer.with(user:).no_balance_mail
  end
end
