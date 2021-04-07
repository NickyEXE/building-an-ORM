class Tweet

  attr_accessor :author, :content, :id

  # author: "dril"
  def initialize(hash={})
    hash.each do |key, val|
      if self.respond_to?("#{key.to_s}=")
        self.send("#{key.to_s}=", val)
      end
    end
  end

  def self.create(hash)
    Tweet.new(hash).save
  end

  def update(hash)
    hash.each do |key, val|
      if self.respond_to?("#{key.to_s}=")
        self.send("#{key.to_s}=", val)
      end
    end
    self.save
  end

  def save
    if self.id
      # update the record
      sql = <<-SQL
        UPDATE tweets
        SET author = ?, content = ?
        WHERE id = ?;
      SQL
      DB[:conn].execute(sql, self.author, self.content, self.id)
    else
      # create the record
      sql = <<-SQL
        INSERT INTO tweets (author, content)
        VALUES (?, ?);
      SQL
      DB[:conn].execute(sql, self.author, self.content)
      self.id = DB[:conn].last_insert_row_id
    end
    self
  end

  def delete
    sql = <<-SQL
      DELETE FROM tweets
      WHERE id = ?;
    SQL
    DB[:conn].execute(sql, self.id)
    true
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM tweets
      WHERE id = ?
      LIMIT 1;
    SQL
    Tweet.new(DB[:conn].execute(sql, id).first)
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS tweets (
        id INTEGER PRIMARY KEY,
        author TEXT,
        content TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.all
    hashes = DB[:conn].execute("SELECT * FROM tweets;")
    hashes.map do |hash|
      Tweet.new(hash)
    end
  end

  def self.delete_all
    DB[:conn].execute("DELETE FROM tweets;")
  end

end
