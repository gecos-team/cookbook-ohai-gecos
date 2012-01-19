provides 'sources_list'

sources_list Mash.new

Dir['/etc/apt/sources.list', '/etc/apt/sources.list.d/*.list'].each do |filename|
  open(filename).readlines.grep(/^deb/).each do |line|
    matches = line.match(/((?:http|https):\/\/[\S]*) (\w+|\w+-\w+) ([\w ]+)/)
    url = matches[1].chomp('/')
    suite = matches[2]
    components = matches[3].split
    index = url + '_' +suite
    sources_list[index] = Mash.new({
                                  :components => components,
                                  :suite => suite,
                                  :server => url
                                  })
  end
end
