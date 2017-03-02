# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'csv'
require 'open-uri'
require 'json'
require 'date'

context 'Check holidays.yml by syukujitsu.csv' do
  before do
    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
    csv_url = 'http://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv'
    csv = open(csv_url).read
    @cholidays = CSV.parse(csv, headers: true, encoding: 'Shift_JIS')
  end

  it 'holidays.yml shoud have date of syukujitsu.csv' do
    @cholidays.each do |row|
      d = Date::parse(row[0])
      expect(@holidays.key?(d)).to eq true
      expect(@holidays[d]).to eq row[1].encode('UTF-8', 'Shift_JIS')
    end
  end
end
