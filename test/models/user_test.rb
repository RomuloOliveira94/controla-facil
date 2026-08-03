require 'test_helper'

# Canário de collation/normalização de e-mail.
#
# Hoje o MySQL usa utf8mb4_0900_ai_ci (case-insensitive), então comparações de
# e-mail ignoram maiúsculas por acidente do banco. No SQLite a comparação de
# texto é case-sensitive (BINARY), então esse acidente desaparece.
#
# O que protege a aplicação não é a collation e sim o `normalizes :email` do
# revise_auth: no Rails 7.1 ele normaliza tanto a ESCRITA quanto o VALOR
# CONSULTADO em finders (where/find_by). É por isso que
# `providers_controller.rb:6` (`User.find_by(email:)`, com o e-mail cru vindo do
# OAuth) continua correto depois da migração para SQLite.
#
# Estes testes travam esse contrato: se alguém remover o `normalizes` ou trocar
# o finder por SQL cru (`where('email = ?', x)`), o login por Google quebra
# silenciosamente no SQLite.
class UserTest < ActiveSupport::TestCase
  test 'normaliza o e-mail na escrita' do
    user = create_user(email: ' Foo@BAR.com ')

    assert_equal 'foo@bar.com', user.email
    assert_equal 'foo@bar.com', user.reload.email
  end

  test 'normaliza o unconfirmed_email na escrita' do
    user = create_user(email: 'foo@bar.com', unconfirmed_email: ' Novo@BAR.com ')

    assert_equal 'novo@bar.com', user.reload.unconfirmed_email
  end

  test 'find_by normaliza o valor consultado, sem depender da collation' do
    user = create_user(email: ' Foo@BAR.com ')

    assert_equal user, User.find_by(email: ' FOO@bar.COM ')
    assert_equal user, User.find_by(email: 'foo@bar.com')
  end

  test 'find_by com e-mail cru do OAuth encontra o usuário existente' do
    user = create_user(email: 'foo@bar.com')

    # Mesma chamada de ProvidersController#start_google_session.
    assert_equal user, User.find_by(email: 'Foo@Bar.com')
  end

  test 'find_by não encontra usuário de e-mail diferente' do
    create_user(email: 'foo@bar.com')

    assert_nil User.find_by(email: 'outro@bar.com')
  end

  test 'normalize_value_for expõe a mesma normalização usada na escrita' do
    user = create_user(email: ' Foo@BAR.com ')

    assert_equal user.email, User.normalize_value_for(:email, ' FOO@bar.COM ')
    assert_nil User.normalize_value_for(:email, nil)
  end
end
