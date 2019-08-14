ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    domain: '167.71.68.128',
    user_name: Rails.application.credentials[Rails.env.to_sym][:sendgrid][:username],
    password: Rails.application.credentials[Rails.env.to_sym][:sendgrid][:password],
    authentication: :login,
    enable_starttls_auto: true
}