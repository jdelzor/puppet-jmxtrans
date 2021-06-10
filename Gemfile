source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet"
  gem "rspec"
  gem "parallel_tests"
  gem 'rspec-puppet', '~> 2.9'
  gem "puppetlabs_spec_helper"
  gem "puppet_metadata", '~> 0.3.0'
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'rubocop', '= 1.6.1'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'voxpupuli-acceptance', '~> 0.3.0'

  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "puppet-blacksmith"
  gem "guard-rake"
  gem "puppet-strings"
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end
