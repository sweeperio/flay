When(/I bundle install/) do
  run_simple "bundle install", fail_on_error: true, exit_timeout: 60
end

When(/I run "(.*)" with bundle exec/) do |task|
  run_simple "bundle exec #{task}", fail_on_error: true, exit_timeout: 10
end
