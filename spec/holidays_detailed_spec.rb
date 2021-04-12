# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'json'
require 'date'

context 'Emperor\'s Birthday' do
  before do
    @holidays_detailed = YAML.load_file(File.expand_path('../../holidays_detailed.yml', __FILE__))
  end

  it 'holidays_detail.yml should have holiday in Showa Emperor\'s Birthday' do
    1970.upto(1988) do |year|
      expect(@holidays_detailed.key?(Date.new(year, 4, 29))).to eq true
    end
  end

  it 'holidays_detail.yml should have holiday in Heisei Emperor\'s Birthday' do
    1989.upto(2018) do |year|
      expect(@holidays_detailed.key?(Date.new(year, 12, 23))).to eq true
    end
  end

  it 'holidays_detail.yml should have no holiday in 2019 Emperor\'s Birthday' do
    expect(@holidays_detailed.key?(Date.new(2019, 2, 23))).to eq false
    expect(@holidays_detailed.key?(Date.new(2019, 12, 23))).to eq false
  end

  it 'holidays_detail.yml should have holiday in New Emperor\'s Birthday' do
    2020.upto(2050) do |year|
      expect(@holidays_detailed.key?(Date.new(year, 2, 23))).to eq true
    end
  end
end

context 'Holiday in lieu' do
  before do
    @holidays_detailed = YAML.load_file(File.expand_path('../../holidays_detailed.yml', __FILE__))
  end

  it 'If holiday is Sunday, Holiday in lieu should exist. (>= 1973.4.30)' do
    @holidays_detailed.each do |date, detail|
      if date >= Date.new(1973, 4, 30) && date.wday == 0 && !detail['name'].match(/振替休日/)
        expect(@holidays_detailed.key?(date + 1)).to eq true
      end
    end
  end
end

context 'Tokyo Olympic' do
  before do
    @holidays_detailed = YAML.load_file(File.expand_path('../../holidays_detailed.yml', __FILE__))
  end

  it 'If tokyo olympic year, 海の日 should be moved' do
    expect(@holidays_detailed.key?(Date::parse('2020-07-20'))).to eq false
    expect(@holidays_detailed.key?(Date::parse('2020-07-23'))).to eq true
  end

  it 'If tokyo olympic year, 山の日 should be moved' do
    expect(@holidays_detailed.key?(Date::parse('2020-08-11'))).to eq false
    expect(@holidays_detailed.key?(Date::parse('2020-08-10'))).to eq true
  end

  it 'If tokyo olympic year, 体育の日 should be moved' do
    expect(@holidays_detailed.key?(Date::parse('2020-10-12'))).to eq false
    expect(@holidays_detailed.key?(Date::parse('2020-07-24'))).to eq true
  end

  it 'If tokyo olympic 2021, 海の日 should be moved' do
    expect(@holidays_detailed.key?(Date::parse('2021-07-19'))).to eq false
    expect(@holidays_detailed.key?(Date::parse('2021-07-22'))).to eq true
  end

  it 'If tokyo olympic 2021, 山の日 should be moved' do
    expect(@holidays_detailed.key?(Date::parse('2021-08-11'))).to eq false
    expect(@holidays_detailed.key?(Date::parse('2021-08-08'))).to eq true
    expect(@holidays_detailed.key?(Date::parse('2021-08-09'))).to eq true
  end

  it 'If tokyo olympic 2021, スポーツの日 should be moved' do
    expect(@holidays_detailed.key?(Date::parse('2021-10-11'))).to eq false
    expect(@holidays_detailed.key?(Date::parse('2021-07-23'))).to eq true
  end
end

context 'Coronation Day / 天皇の即位の日及び即位礼正殿の儀の行われる日を休日とする法律' do
  before do
    @holidays_detailed = YAML.load_file(File.expand_path('../../holidays_detailed.yml', __FILE__))
  end
  it '天皇の即位の日の平成31年（2019年）5月1日及び即位礼正殿の儀が行われる日の平成31年（2019年）10月22日は、休日となります' do
    expect(@holidays_detailed.key?(Date::parse('2019-05-01'))).to eq true
    expect(@holidays_detailed.key?(Date::parse('2019-10-22'))).to eq true
  end
  it 'また、これらの休日は国民の祝日扱いとなるため、平成31年（2019年）４月30日と５月２日も休日となります' do
    expect(@holidays_detailed.key?(Date::parse('2019-04-30'))).to eq true
    expect(@holidays_detailed.key?(Date::parse('2019-05-02'))).to eq true
  end
end

context 'holiday.yml' do
  before do
    @holidays_detailed = YAML.load_file(File.expand_path('../../holidays_detailed.yml', __FILE__))
  end

  it 'holidays_detailed.yml should have date of holiday.yml and holiday.yml should have of holiday_detail.yml' do
    holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
    holidays.each do |date, name|
      expect(@holidays_detailed.key?(date)).to eq true
      expect(@holidays_detailed[date]['name']).to eq name
    end
    @holidays_detailed.each do |date, detail|
      expect(holidays.key?(date)).to eq true
      expect(holidays[date]).to eq detail['name']
    end
    expect(holidays.length).to eq @holidays_detailed.length
  end
end
