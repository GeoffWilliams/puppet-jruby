source ENV['GEM_SOURCE'] || 'https://rubygems.org'
case RUBY_PLATFORM
when /darwin/
  gem 'CFPropertyList'
end
gem 'puppet', '4.9.0'
gem 'facter', '2.4.6'
gem 'rubocop', '0.47.1'
gem 'rspec-puppet-facts', '1.7.0'

# Workaround for PDOC-160
gem 'puppet-strings',
  :git => 'https://github.com/declarativesystems/puppet-strings',
  :ref => 'no_dates'
gem 'pdqtest', '0.3.1'
