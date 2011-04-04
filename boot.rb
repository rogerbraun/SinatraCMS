require "./models.rb"
require "./db.rb"
require "./helpers.rb"
require "./app.rb"
DataMapper::Model.raise_on_save_failure = true

PLUGINS = []
require "./plugins/rss_reader.rb"
PLUGINS << RSSReader.new
