provides 'sources_list'

sources_list Mash.new

Dir['/etc/apt/sources.list', '/etc/apt/sources.list.d/*.list'].each do |filename|
  open(filename).readlines.grep(/^deb/).each do |line|
    matches = line.match(/((?:http|https):\/\/[\S]*) (\w+|\w+-\w+) ([\w ]+)/)
    url = matches[1].chomp('/')
    sources_list[url] = Mash.new({
                                    :suite      => matches[2],
                                    :components => matches[3].split
                                  })
  end
end
