require "sqlite3"

$db = SQLite3::Database.new "test.db"

$db.execute <<-SQL
  CREATE TABLE signals (
    strategy_id varchar(50),
    expirate_at varchar(50)
  );
SQL
