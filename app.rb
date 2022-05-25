require 'sinatra/base'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'

class App < Sinatra::Base
  not_found do
    @title = 'Not Found'
    erb :blank
  end
  error do
    @title = 'Error'
    erb :blank
  end
  get '/' do
    @title = 'TOTO odds search'
    @sch = OddsSearch.new.schedule
    erb :index
  end
end

class OddsSearch
  def schedule
    url = "https://toto.yahoo.co.jp/schedule/toto"
    html = URI.open(url){ |f| f.read }
    doc = Nokogiri::HTML.parse(html)
    h = Hash.new
    doc.css("tr.schedule_back a").each_with_index do |tr, i|
      if tr.attribute("href").value.include?("hold_id=")
        h[i] = tr.attribute("href").value.split("hold_id=")[1].to_i
      end
    end
    h.values
  end
end