class NormalizeUserEmails < ActiveRecord::Migration[7.1]
  def up
    User.reset_column_information
    User.find_each do |u|
      normalized = u.email.to_s.strip.downcase
      unconfirmed = u.unconfirmed_email&.strip&.downcase
      next if normalized == u.email && unconfirmed == u.unconfirmed_email

      u.update_columns(email: normalized, unconfirmed_email: unconfirmed)
    end
  end

  def down; end
end
