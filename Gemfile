# source 'https://rubygems.org'
source 'http://ruby.taobao.org/'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
gem 'grape'
gem 'mysql2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'grape-shaman_cache', '0.3.0'
gem 'grape-jbuilder'
gem 'grape-kaminari'
gem 'acts-as-taggable-on'
gem 'newrelic-grape', :git => 'https://github.com/flyerhzm/newrelic-grape.git'
# https://github.com/collectiveidea/awesome_nested_set
gem 'awesome_nested_set', '~> 3.0.0.rc.1'
# https://github.com/radar/paranoia
gem 'paranoia', '~> 2.0.1'
gem 'china_sms'
gem 'bluestorm_sms', '0.0.6', github: 'wjp2013/bluestorm_sms'
gem 'dalli', github: 'mperham/dalli'
gem 'igetui-ruby', '1.2.2', require: 'igetui'

# Because activesupport doesn't encoding invalid code anymore.
# Add activesupport-json_encoder gem to Gemfile fix this issue.
# https://github.com/rails/rails/issues/15226
gem 'activesupport-json_encoder'

gem 'mini_magick'
gem 'carrierwave'
gem 'rest-client'
gem 'carrierwave-aliyun'

group :development do
  gem 'spring'
  # Use mina for deployment
  # https://github.com/nadarei/mina
  gem 'mina'
  # A robust Ruby code analyzer, based on the community Ruby style guide.
  # https://github.com/bbatsov/rubocop
  gem 'rubocop', require: false
  gem 'guard'
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
end

group :test do
  gem 'sqlite3'
  gem 'minitest-rails'
  gem 'minitest-focus'
  gem 'minitest-reporters'
  gem 'database_cleaner'
end

group :development, :test do
  # gem 'api_taster', '0.6.0'
  gem 'pry-byebug'
end

group :production do
  gem 'puma'
end
