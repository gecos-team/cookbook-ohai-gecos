class Ini
  def initialize(path=nil, load=nil, raw=nil)
    @path = path
    @raw = raw
    @inihash = {}

    if load or ( load.nil? and not @path.nil? and FileTest.readable_real? @path ) or not @raw.nil?
      restore()
    end
  end

  def get_inihash()
    @inihash
  end

  def [](key)
    @inihash[key]
  end

  def get_path()
    @path
  end


  def []=(key, value)
    raise TypeError, "String expected" unless key.is_a? String
    raise TypeError, "String or Hash expected" unless value.is_a? String or value.is_a? Hash

    @inihash[key] = value
  end

  def restore()
    @inihash = Ini.read_from_file(@path, @raw)
  end
  def update()
    Ini.write_to_file(@path, @inihash)
  end

  def Ini.parse(line, inihash, headline)
    line = line.strip.split(/#/)[0]
    if not line.nil?
      # read it only if the line doesn't begin with a "=" and is long enough
      unless line.length < 2 and line[0,1] == "="

        # it's a headline if the line begins with a "[" and ends with a "]"
        if line[0,1] == "[" and line[line.length - 1, line.length] == "]"

          # get rid of the [] and unnecessary spaces
          headline = line[1, line.length - 2 ].strip
          inihash[headline] = {}
        else

          key, value = line.split(/=/, 2)

          key = key.strip unless key.nil?
          value = value.strip unless value.nil?
          unless headline.nil?
            inihash[headline][key] = value
          else
            inihash[key] = value unless key.nil?
          end
        end
      end
    end   
    return inihash, headline
  end

  def Ini.read_from_file(path=nil, raw=nil)
    inihash = {}
    headline = nil
    if not raw.nil?
      raw.split("\n").each do |line|
        inihash, headline = Ini.parse(line, inihash, headline)
      end
    else
      IO.foreach(path) do |line|
        inihash, headline = Ini.parse(line, inihash, headline)
      end
    end

    inihash
  end

  def Ini.write_to_file(path, inihash={})
    raise TypeError, "Hash expected" unless inihash.is_a? Hash
    File.open(path, "w") { |file|


      file << Ini.to_s(inihash)
    }
  end

  def Ini.to_s(inihash={})
    str = ""

    inihash.each do |key, value|

      if value.is_a? Hash
        str << "[#{key.to_s}]\n"

        value.each do |under_key, under_value|
          str << "#{under_key.to_s}=#{under_value.to_s unless under_value.nil?}\n"
        end

      else
        str << "#{key.to_s}=#{value.to_s unless value2.nil?}\n"
      end
    end

    str
  end

end

require_plugin "users"
users = get_attribute('users')

users.each do |user|
  username = user['username']

  dconf_raw = %x[sudo -iu #{username} dconf dump /]
  dconf = Ini.new(nil, nil, raw=dconf_raw).get_inihash()

  users[username]['dconf'] = dconf
end
