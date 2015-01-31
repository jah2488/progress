require 'securerandom'
class Repository
  attr_reader :tables

  def initialize
    @tables = {}
  end

  def [](type)
    @tables.fetch(type)[:records]
  end

  def register_type(type, location, load_records = false)
    set(type, {
      class: type,
      location: location,
      records: []
    })
    load(type, location) if load_records
    self
  end

  def load(type, loc = nil)
    location = loc || get(type).location
    records  = JSON.parse(File.open(location).read) # Currently loading from file system, but no reason it couldn't be from any api
    get(type)[:records] = records.map do |record|
      type.new(to_sym_hash(record))
    end
  end

  def save(type, record)
    repo = @tables.fetch(type)
    repo[:records] << repo[:class].new(record.merge({ id: ::SecureRandom.uuid }))

    write(repo)
  end

  def update(type, record)
    repo = @tables.fetch(type)
    repo[:records] = repo[:records].map do |old_record|
      if old_record.opts[:id] == record.opts[:id]
        record
      else
        old_record
      end
    end

    write(repo)
  end

  def write(repo)
    `cp #{repo[:location]} #{repo[:location]}.bk` # create a backup of the file on each save
    File.write(repo[:location], repo[:records].to_json)
  end

  private

  def get(type)
    @tables[to_n(type)]
  end

  def set(type, val)
    @tables[to_n(type)] = val
  end

  def to_sym_hash(hash)
    Hash[hash.map { |k, v| [k.to_sym, v] }]
  end

  def to_n(type)
    (type.to_s.downcase << 's').to_sym
  end
end
