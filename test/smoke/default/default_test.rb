# # encoding: utf-8

# Inspec test for recipe hab_studio_environment::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# This is an example test, replace it with your own test.
describe command('hab --version') do
  its('stdout') { should_not be_nil }
  its('stdout') { should match(/hab\s+\d+/)}
end