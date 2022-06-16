require 'sinatra/base'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'
require 'json'

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
    if params[:hold].nil?.!
      Goal3OddsSearch.new(params[:hold]).odds_goal3
      t = File.read("dat/totogoal3_" + params[:hold] + ".json") do |f|
        JSON.load(f)
      end
      @odds = JSON.parse(t)
    end
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
    
    votes = Hash.new{ |h, k| h[k] = {} }

    doc.css('td.td_team').each_with_index do |td, i|
      votes[i + 1]["team_name"] = td.text
    end
    doc.css('td.zero_bar img').each_with_index do |td, i|
      votes[i + 1][0] = td.attribute('title').value.to_f
    end
    doc.css('td.one_bar img').each_with_index do |td, i|
      votes[i + 1][1] = td.attribute('title').value.to_f
    end
    doc.css('td.two_bar img').each_with_index do |td, i|
      votes[i + 1][2] = td.attribute('title').value.to_f
    end
    doc.css('td.three_bar img').each_with_index do |td, i|
      votes[i + 1][3] = td.attribute('title').value.to_f
    end

    savefile = JSON.parse(votes.to_json)
    File.open("dat/totogoal3_" + @hold + ".json", "w") do |f|
      JSON.dump(savefile, f)
    end
  end
end