class NoBalanceMailerPreview < ActionMailer::Preview
  def no_balance_mail
    NoBalanceMailer.with(user: User.first).no_balance_mail
  end
end
