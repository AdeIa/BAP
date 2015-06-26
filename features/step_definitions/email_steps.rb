Then /^"([^"]*)" receives an email with "([^"]*)" as the subject$/ do |email_address, subject|
  open_email(email_address)
  expect(current_email.subject).to eq subject
end
