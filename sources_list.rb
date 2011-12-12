provides 'sources_list'

sources_list Mash.new

def parse_sources(filename)

  repos = []

  f = File.open(filename, "r")
  f.each_line do |repo|
    if /^deb\s/.match(repo)
      repos << repo
    end
  end
  f.close()

  return repos
end


repos = parse_sources('/etc/apt/sources.list')

Dir["/etc/apt/sources.list.d/*"].each do |filename|
  repos += parse_sources(filename)
end

repos.each do |repo|

  tokens = repo.split()
  repo_url = tokens[1]
  branch = tokens[2]

  if not sources_list.key?(repo_url)
    sources_list[repo_url] = Mash.new()
  end

  if not sources_list[repo_url].key?(branch)
    sources_list[repo_url][branch] = []
  end

  for i in 3..tokens.length-1
    component = tokens[i]
    sources_list[repo_url][branch] << component
  end

end
