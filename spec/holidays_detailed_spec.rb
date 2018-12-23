# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'json'
require 'date'

context 'holidays_detailed.yml' do
  before do
    @holidays_detailed = YAML.load_file(File.expand_path('../../holidays_detailed.yml', __FILE__))
    @v1 = YAML.load_file(File.expand_path('../../holidays_detailed.v1.x.yml', __FILE__))
  end

  it 'holidays_detailed.yml should have date of holiday_detailed.v1.x.yml' do
    @holidays_detailed.each do |date, detail|
      expect(@v1.key?(date)).to eq true
      if detail['name'] == '振替休日'
        expect(@v1[date]['name']).to match(/ 振替休日\z/)
      else
        expect(@v1[date]).to eq(detail)
      end
    end
    @v1.each do |date, detail|
      expect(@holidays_detailed.key?(date)).to eq true
      if / 振替休日\z/ =~ detail['name']
        expect(@holidays_detailed[date]['name']).to eq('振替休日')
      else
        expect(@holidays_detailed[date]).to eq(detail)
      end
    end
    expect(@holidays_detailed.length).to eq @v1.length
  end
end
