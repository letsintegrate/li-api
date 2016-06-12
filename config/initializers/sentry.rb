Raven.configure do |config|
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.dsn = 'https://ae4445f2791d4c6ba136e2af1afdf540:6f111639b3fa4bc3bf616d5e6dbffa8c@app.getsentry.com/82283'
  config.environments = ['staging', 'production']
end
