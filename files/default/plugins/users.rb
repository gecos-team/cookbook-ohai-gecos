provides 'users'

require 'etc'

users Array.new

Dir["/home/*"].each do |homedir|
  Etc.passwd do |entry|
    next unless homedir == entry.dir
    users << Mash.new(
      :username => entry.name,
      :gid      => entry.gid,
      :uid      => entry.uid
    )
  end
end
