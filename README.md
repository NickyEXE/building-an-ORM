# Building an ORM


## Tips

### Returning Hashes
SQLite database instances can be set to return values as hashes with
`.results_as_hash = true`

### Avoiding SQL Injection Attacks

Never string interpolate into your SQL. Instead, use `?` where you'd put a value, and then add the values as arguments to your `execute` call in the order that you'd like them replaced. For instance:

```ruby
  sql = <<-SQL
    UPDATE tweets
    SET content = ?, author = ?
    WHERE id = ?;
  SQL
  DB[:conn].execute(sql, self.content, self.author, self.id)
```

This way, someone tweeting "; DROP TABLE tweets;" won't delete all your tweets.
