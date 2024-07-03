ReviseAuth.configure do |config|
  # Customize the params for registration and update profile.
  # config.sign_up_params += [:time_zone]
  # config.update_params += [:time_zone]
  config.minimum_password_length = 6
  config.sign_up_params += %i[first_name last_name avatar]
  config.update_params += %i[first_name last_name avatar]
end
