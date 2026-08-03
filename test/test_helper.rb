ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Builds a valid user without relying on fixtures or seed data.
    def create_user(email: 'user@example.com', **attributes)
      User.create!(
        email:,
        first_name: 'Test',
        last_name: 'User',
        password: 'senha-super-secreta',
        **attributes
      )
    end

    # Builds a valid category without relying on fixtures or seed data.
    def create_category(name:, cat_sub:, **attributes)
      Category.create!(name:, cat_sub:, icon: 'fas fa-question-circle', **attributes)
    end
  end
end
