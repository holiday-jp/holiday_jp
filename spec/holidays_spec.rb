# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'json'
require 'date'

context 'holidays.yml' do
  before do
    @holidays = YAML.load_file(File.expand_path('../../holidays.yml', __FILE__))
    @v1 = YAML.load_file(File.expand_path('../../holidays.v1.x.yml', __FILE__))
  end

  it 'holidays.yml should have date of holiday.v1.x.yml' do
    @holidays.each do |date, detail|
      expect(@v1.key?(date)).to eq true
      expect(@v1[date]).to eq(detail).or match(/ 振替休日\z/)
    end
    @v1.each do |date, detail|
      expect(@holidays.key?(date)).to eq true
      expect(@holidays[date]).to eq(detail).or eq('振替休日')
    end
    expect(@holidays.length).to eq @v1.length
  end
end
