class Tweet 

    attr_accessor :content, :author, :id

    def initialize(attr_hash={})
        #is NOT responsible for sending attributes to the db
        # is resonsible for assign the attributes that we get FROM the db to objects
        attr_hash.each do |key, value|
            if self.respond_to?("#{key.to_s}=")
                self.send("#{key.to_s}=", value)
            end
            #self.content=(value)
        end
        #{content: Faker::Quote.matz, author: 'Matz'}
    end

    def self.all
       array_of_hashes = DB[:conn].execute("SELECT * FROM tweets")
       array_of_hashes.collect do |hash|
         self.new(hash)
       end
    end

    def self.find(id)
        sql = "SELECT * from tweets WHERE tweets.id = ?"
        obj_hash = DB[:conn].execute(sql, id)[0]
        self.new(obj_hash)
    end


    def save 
        # add the attr_accessor data to the db

       
        if !!self.id  
             # if it is already saved, update it 
             sql = <<-SQL 
                UPDATE tweets
                SET content = ?, author = ?
                WHERE id = ?;
             SQL
             DB[:conn].execute(sql, self.content, self.author, self.id)
        else
            # if it is not already saved, add to db
            sql = <<-SQL 
                INSERT INTO tweets (content, author) 
                VALUES (?,?)
            SQL
            DB[:conn].execute(sql, @content, self.author)
            @id = DB[:conn].last_insert_row_id
        end
        self
    end

    def self.create_table 
        # responsible for creating a class
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS tweets (
                id INTEGER PRIMARY KEY,
                content TEXT,
                author TEXT
            )
        SQL

        DB[:conn].execute(sql)
    end
end