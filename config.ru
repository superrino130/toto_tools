require './app'
require './goal3'

map('/') { run App }
map('/goal3') { run Goal3 }

