# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'csv'
require 'open-uri'
require 'date'

context 'Check holidays.yml by syukujitsu.csv' do
  before do
    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
    csv_url = 'https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv'
    csv = open(csv_url).read
    @cholidays = CSV.parse(csv, headers: true, encoding: 'Shift_JIS')
  end

  it '3条1項 「国民の祝日」は、休日とする。' do
    @cholidays.each do |row|
      d = Date::parse(row[0])
      expect(@holidays.key?(d)).to eq true
      expect(@holidays[d]).to eq row[1].encode('UTF-8', 'Shift_JIS')
    end
  end

  it '3条2項 「国民の祝日」が日曜日に当たるときは、その日後においてその日に最も近い「国民の祝日」でない日を休日とする。' do
    @cholidays.each do |row|
      d = Date::parse(row[0])
      expect(@holidays.key?(d + 1)).to eq true if d.sunday?
    end
  end

  it '3条3項 その前日及び翌日が「国民の祝日」である日（「国民の祝日」でない日に限る。）は、休日とする。' do
    @cholidays.each do |row|
      d = Date::parse(row[0])
      key = (d + 2).strftime('%Y-%m-%d')
      expect(@holidays.key?(d + 1)).to eq true if @cholidays.find do |r|
        r[0] == key
      end
    end
  end
end
