When(/I bundle install/) do
  run_simple "bundle install", fail_on_error: true, exit_timeout: 60
end

When(/I run "(.*)" with bundle exec/) do |task|
  run_simple "bundle exec #{task}", fail_on_error: true, exit_timeout: 10
end

Given(/I generate a recipe named "(.+)"$/) do |cbname|
  run_simple "chef generate recipe #{cbname} -g #{File.join(Dir.pwd, 'shared', 'flavor', 'flay')}"
end

Then(/^the file "([^"]*)" should contain$/) do |path, string|
  expect(path).to have_file_content(file_content_including(string.chomp))
end
