# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'json'
require 'date'
require 'google_holiday_calendar'

context 'holidays.yml by Google Calendar' do
  before do
    today = Date::today
    start_date = today - 365
    end_date = start_date + 365 * 2

    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
    @google_calendar = GoogleHolidayCalendar::Calendar.new(country: 'japanese', lang: 'ja', api_key: ENV['GOOGLE_CALENDAR_API_KEY'])
    @gholidays = @google_calendar.holidays(start_date: start_date, end_date: end_date, limit: 50)
    @span = @holidays.select do |date|
      date.between?(start_date, end_date)
    end
  end

  it 'Google calendar result should have date of holidays.yml' do
    @span.each do |date|
      expect(@google_calendar.holiday?(date[0])).to eq true
    end
  end

  it 'holidays.yml shoud have date of Google calendar' do
    @gholidays.each do |date, name|
      expect(@holidays.key?(date)).to eq true
      expect(@holidays[date]).to eq name
    end
  end

  it 'holidays.yml should have holiday in lieu of `Mountain Day`' do
    expect(@holidays.key?(Date::parse('2019-08-12'))).to eq true
    expect(@holidays.key?(Date::parse('2024-08-12'))).to eq true
    expect(@holidays.key?(Date::parse('2030-08-12'))).to eq true
    expect(@holidays.key?(Date::parse('2041-08-12'))).to eq true
    expect(@holidays.key?(Date::parse('2047-08-12'))).to eq true
  end
end

context 'Emperor\'s Birthday' do
  before do
    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
  end

  it 'holidays.yml should have holiday in Showa Emperor\'s Birthday' do
    1970.upto(1988) do |year|
      expect(@holidays.key?(Date.new(year, 4, 29))).to eq true
    end
  end

  it 'holidays.yml should have holiday in Heisei Emperor\'s Birthday' do
    1989.upto(2018) do |year|
      expect(@holidays.key?(Date.new(year, 12, 23))).to eq true
    end
  end

  it 'holidays.yml should have no holiday in 2019 Emperor\'s Birthday' do
    expect(@holidays.key?(Date.new(2019, 2, 23))).to eq false
    expect(@holidays.key?(Date.new(2019, 12, 23))).to eq false
  end

  it 'holidays.yml should have holiday in New Emperor\'s Birthday' do
    2020.upto(2050) do |year|
      expect(@holidays.key?(Date.new(year, 2, 23))).to eq true
    end
  end
end

context 'Holiday in lieu' do
  before do
    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
  end

  it 'If holiday is Sunday, Holiday in lieu should exist. (>= 1973.4.30)' do
    @holidays.each do |date, name|
      if date >= Date.new(1973, 4, 30) && date.wday == 0 && !name.match(/振替休日/)
        expect(@holidays.key?(date + 1)).to eq true
      end
    end
  end
end

context 'Tokyo Olympic' do
  before do
    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
  end

  it 'If tokyo olympic year, 海の日 should be moved' do
    expect(@holidays.key?(Date::parse('2020-07-20'))).to eq false
    expect(@holidays.key?(Date::parse('2020-07-23'))).to eq true
  end

  it 'If tokyo olympic year, 山の日 should be moved' do
    expect(@holidays.key?(Date::parse('2020-08-11'))).to eq false
    expect(@holidays.key?(Date::parse('2020-08-10'))).to eq true
  end

  it 'If tokyo olympic year, 体育の日 should be moved' do
    expect(@holidays.key?(Date::parse('2020-10-12'))).to eq false
    expect(@holidays.key?(Date::parse('2020-07-24'))).to eq true
  end
end
