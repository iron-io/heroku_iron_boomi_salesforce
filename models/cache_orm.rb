class CacheOrm

  def initialize(ironcache)
    @cache = ironcache
  end


  def key_for(idable, id=nil)
    if id
      # idable should be a class
      "#{idable.name.downcase}_#{id}"
    else
      "#{idable.class.name.downcase}_#{idable.id}"
    end
  end

  def save(idable)
    unless idable.id
      idable.id = Idable.generate_id
    end
    put(key_for(idable), idable)

  end

  def get_list(key)
    messages = get(key)
    #puts 'got messages: ' + messages.inspect
    if messages.nil?
      messages = []
    end
    messages
  end

  def add_to_list(key, item)
    messages = get_list(key)
    messages.unshift(item)
    put(key, messages)
  end

  def get(key)
    val = @cache.get(key)
    #puts 'got val: ' + val.inspect
    if val.nil?
      puts "GOT NIL for key #{key}"
      return nil
    end
    val = val.value
    #puts "got from cache #{val}"
    begin
      val = JSON.parse(val)
      if val.is_a?(Hash) && val['string']
        val = val['string']
      end
    rescue => ex
      puts "CAUGHT: #{ex.message}"
    end
    val
  end

  def put(key, value, options={})
    if value.is_a?(String)
      # need to wrap it
      value = {string: value}.to_json
    else
      value = value.to_json
    end
    #puts 'value jsoned: ' + value.inspect
    @cache.put(key, value, options)
  end

  def delete(key)
    @cache.delete(key)
  end

  def increment(key, value=1)
    puts 'INC'
    begin
      ret = @cache.increment(key)
      puts 'INC RET ' + ret.inspect
      return ret.value
    rescue Rest::HttpError, IronCore::ResponseError => ex
      p ex
      puts "couldn't increment #{key}"
      puts ex.message
      p ex.backtrace
      if ex.code == 404
        puts "setting value in cache"
        settings.iron_cache.put(key, 1)
      end
      puts "done increment"
      return 1
    end
    puts 'end inc'
  end

end
