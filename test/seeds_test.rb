require 'test_helper'

# db/seeds.rb usa find_or_create_by! com cat_sub. Enquanto a coluna era ENUM o
# MySQL convertia os inteiros 1/2 em 'expenses'/'incomes' na escrita, mas o
# find_or_create_by! comparava contra os inteiros, então rodar os seeds duas vezes
# duplicava todas as categorias fixas. Este teste trava a idempotência.
class SeedsTest < ActiveSupport::TestCase
  test 'rodar os seeds duas vezes mantém as categorias fixas estáveis' do
    Rails.application.load_seed
    first_run = Category.where(fixed: true).count

    assert_operator first_run, :>, 0

    Rails.application.load_seed

    assert_equal first_run, Category.where(fixed: true).count
  end

  test 'seeds gravam cat_sub como string' do
    Rails.application.load_seed

    assert_equal %w[expenses incomes], Category.where(fixed: true).distinct.pluck(:cat_sub).sort
  end

  test 'seeds criam categorias fixas válidas' do
    Rails.application.load_seed

    Category.where(fixed: true).find_each do |category|
      assert_predicate category, :valid?
    end
  end
end
