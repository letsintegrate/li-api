# Preview all emails at http://localhost:3000/rails/mailers/reports_mailer
class ReportsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reports_mailer/email_address_records
  def email_address_records
    ReportsMailer.email_address_records
  end

end
