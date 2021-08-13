require_relative 'setup_tests'
require_relative '../lib/managers/database_manager'

DBNAME = 'test'.freeze

class DatabaseManagerTest < Test
  def test_table_exists
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    assert_equal(true, db.table_exists?('test'))
    assert_equal(false, db.table_exists?('non_existing_table'))
    db.drop_database
  end

  def test_guid
    assert_equal(true, DatabaseManager.guid.is_a?(String))
  end

  def test_use
    db = DatabaseManager.new
    assert_equal('default', db.name)
    db.use('different')
    assert_equal('different', db.name)

    db2 = DatabaseManager.new('another')
    assert_equal('another', db2.name)
  end

  def test_tables
    db = DatabaseManager.new(DBNAME)
    assert_equal(0, db.tables.length)
    db.create_table('test')
    assert_equal(1, db.tables.length)
    db.drop_database
  end

  def test_database_exists
    db = DatabaseManager.new(DBNAME)
    assert_equal(false, db.database_exists?(DBNAME))
    db.create_table('test')
    assert_equal(true, db.database_exists?(DBNAME))
    db.drop_database
  end

  def test_create_table
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    assert_equal(true, db.table_exists?('test'))
    db.drop_database(DBNAME)
  end

  def test_drop_table
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    assert_equal(true, db.table_exists?('test'))
    db.drop_table('test')
    assert_equal(false, db.table_exists?('test'))
    db.drop_database(DBNAME)
  end

  def test_count
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    db.save('test', {'color' => 'red'})
    db.save('test', {'color' => 'red'})
    db.save('test', {'color' => 'red'})
    db.save('test', {'color' => 'blue'})
    assert_equal(4, db.count('test', {}))
    assert_equal(3, db.count('test', {'color' => 'red'}))
    db.drop_database(DBNAME)
  end

  def test_delete
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    db.save('test', {}, 1)
    db.save('test', {}, 2)
    assert_equal(2, db.count('test', {}))
    db.delete('test', 2)
    assert_equal(1, db.count('test', {}))
    db.drop_database(DBNAME)
  end

  def test_retrieve
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    db.save('test', {'name' => 'bob'}, 1)
    db.save('test', {'name' => 'dale'}, 2)
    db.save('test', {'name' => 'kevin'}, 3)

    record = db.retrieve('test', 2)
    assert_equal('dale', record['name'])
    db.drop_database(DBNAME)
  end

  def test_find
    db = DatabaseManager.new(DBNAME)
    db.create_table('test')
    db.save('test', {'name' => 'bob'}, 1)
    db.save('test', {'name' => 'dale'}, 2)
    db.save('test', {'name' => 'kevin'}, 3)

    record = db.find('test', {'name' => 'dale'}).first
    assert_equal('dale', record['name'])
    db.drop_database(DBNAME)
  end
end
