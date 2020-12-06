require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
require 'open-uri'
require 'uri'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :holidays do
  desc 'v1のYAMLからのv0の生成'
  task :convert_from_v1 do
    data = YAML.load(URI.open('https://raw.githubusercontent.com/holiday-jp/holiday_jp/master/holidays.yml'))
    data = data.map do |v|
      v[1] = '振替休日' if v[1].match(/振替休日/)
      v[1] = '国民の休日' if v[1] == '休日'
      v
    end.to_h
    YAML.dump(data, File.open('holidays.yml', 'w'))

    data = YAML.load(URI.open('https://raw.githubusercontent.com/holiday-jp/holiday_jp/master/holidays_detailed.yml'))
    data = data.map do |v|
      v[1]['name'] = '振替休日' if v[1]['name'].match(/振替休日/)
      v[1]['name'] = '国民の休日' if v[1]['name'] == '休日'
      v
    end.to_h
    YAML.dump(data, File.open('holidays_detailed.yml', 'w'))
  end
end
