require 'sequel'

# database connection
# create a dbase file, e.g /db/production.db depending on the RACK_ENV env variable
DB = Sequel.sqlite("./db/#{ENV.fetch('RACK_ENV', 'development')}.db")