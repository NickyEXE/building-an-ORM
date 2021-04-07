require 'bundler'
Bundler.require

DB = {conn: SQLite3::Database.new('db/twitter.db')}
DB[:conn].results_as_hash = true

require_relative "../lib/tweet"
require_relative "../db/seed"

Tweet.create_table
