DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3:db/dev.db")
DataMapper.auto_upgrade!
