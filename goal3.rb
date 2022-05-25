require 'sinatra/base'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'

class Goal3 < Sinatra::Base
  not_found do
    @title = "Not Found2"
    erb :blank
  end
  error do
    @title = "Error"
    erb :blank
  end
  get '/:hold' do
    @title = "TOTO Goal3"
    @odds = Goal3OddsSearch.new(params[:hold]).odds_goal3 if params[:hold].nil?.!
    erb :goal3
  end
end

class Goal3OddsSearch
  def initialize(hold)
    @hold = hold
  end

  def odds_goal3
    url = 'https://toto.yahoo.co.jp/vote/toto?id=' + @hold
    html = URI.open(url){ |f| f.read }
    doc = Nokogiri::HTML.parse(html)
    
    votes = Array.new(6){ Array.new(4, 0.0) }
    
    doc.css('td.zero_bar img').each_with_index do |td, i|
      votes[i][0] = td.attribute('title').value.to_f
    end
    doc.css('td.one_bar img').each_with_index do |td, i|
      votes[i][1] = td.attribute('title').value.to_f
    end
    doc.css('td.two_bar img').each_with_index do |td, i|
      votes[i][2] = td.attribute('title').value.to_f
    end
    doc.css('td.three_bar img').each_with_index do |td, i|
      votes[i][3] = td.attribute('title').value.to_f
    end
    votes
  end
end