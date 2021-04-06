class Tweet

  attr_accessor :content, :author
  attr_reader :id

  def initialize(hash={})
    @content = hash["content"] || hash[:content]
    @author = hash["author"] || hash[:author]
    @id = hash["id"] || hash[:id]
  end

  def self.create(hash)
    self.new(hash).save
  end

  def save
    if @id
      sql = <<-SQL
        UPDATE tweets
        SET content = ?, author = ?
        WHERE id = ?;
      SQL
      DB[:conn].execute(sql, content, author, id)
    else
      sql = <<-SQL
        INSERT INTO tweets
        (content, author)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, content, author)
      @id = DB[:conn].last_insert_row_id
    end
    self
  end

  def delete
    sql = <<-SQL
      DELETE FROM tweets WHERE id=?;
    SQL
    DB[:conn].execute(sql, self.id)
    true
  end

  def self.all
    array_of_hashes = DB[:conn].execute("SELECT * FROM tweets;")
    array_of_hashes.map{ |hash| Tweet.new(hash) }
  end

  def self.find(id)
    sql = "SELECT * FROM tweets WHERE tweets.id = ?;"
    Tweet.new(DB[:conn].execute(sql, id)[0])
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS tweets (
        id INTEGER PRIMARY KEY,
        content TEXT,
        author TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.delete_all
    DB[:conn].execute("DELETE FROM tweets;")
  end


end
