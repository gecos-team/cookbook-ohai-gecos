provides 'users'

require 'etc'

users Array.new

# LikeWise create the user homes at /home/local/DOMAIN/
homedirs = Dir["/home/*"] + Dir["/home/local/*/*"]
homedirs.each do |homedir|
  Etc.passwd do |entry|
    next unless homedir == entry.dir
    users << Mash.new(
      :username => entry.name,
      :home     => entry.dir,
      :gid      => entry.gid,
      :uid      => entry.uid
    )
  end
end
