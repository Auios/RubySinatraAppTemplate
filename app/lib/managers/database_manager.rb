require 'mongo'
require 'time'
require 'securerandom'

class DatabaseManager
  # @return [Mongo::Client]
  attr_accessor :client

  def initialize(database = 'default')
    host = ['localhost:27017']

    begin
      @client = Mongo::Client.new(host)
      use(database) if database
    rescue Mongo::Auth::Unauthorized, Mongo::Error => e
      info_string = "Error #{e.class}: #{e.message}"
      puts(info_string)
    end
  end

  def self.guid
    "#{Time.now.to_i}_#{SecureRandom.uuid}"
  end

  def use(database)
    @client = @client.use(database)
  end

  def name
    @client.database.name
  end

  # @return [Mongo::Database]
  def tables
    @client.collections
  end

  def save(table, document, id = nil)
    if document['_id'].nil?
      if id
        document['_id'] = id
      elsif document['_id'].nil?
        document['_id'] = DatabaseManager.guid
      end
    end

    begin
      result = @client[table].insert_one(document).inserted_id
    rescue StandardError
      result = nil
    end

    result
  end

  def delete(table_name, id)
    @client[table_name].delete_one({'_id' => id})
  end

  # @return [Array]
  def find(table, query)
    result = []
    @client[table].find(query).each do |doc|
      result.push(doc)
    end
    result
  end

  def retrieve(table, id, fields = nil)
    result = nil
    @client[table].find({ _id: id }, { projection: fields }).limit(1).each do |doc|
      result = doc
    end
    result
  end

  def count(table, query)
    @client[table].find(query).count
  end

  def create_table(table_name)
    @client[table_name].create unless table_exists?(table_name)
  end

  def table_exists?(table_name)
    @client.database.collection_names.include?(table_name)
  end

  def database_exists?(database_name)
    @client.database_names.include?(database_name)
  end

  def drop_database(database_name = nil)
    if database_name
      @client.use(database_name).database.drop
    else
      @client.database.drop
    end
  end

  def drop_table(table_name)
    @client[table_name].drop
  end
end
