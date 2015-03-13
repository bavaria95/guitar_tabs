require 'sinatra'
require 'json'
require 'active_record'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'Songs.db'
)

class Song < ActiveRecord::Base
	validates :title, presence: true
	validates :tab, presence: true
end


get '/' do
    callback = params.delete('callback') # jsonp
    accords = params['accords']

    # p JSON.parse(accords)

    song = Song.new(title: "test", tab: accords)

    status = song.save
    json = {'status' => status}.to_json

    if callback
      content_type :js
      response = "#{callback}(#{json})" 
    else
      content_type :json
      response = json
    end
    response
  end
