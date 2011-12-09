provides 'home_users'
require 'etc'

home_users Mash.new

etcpasswd = []

Etc.passwd do |entry|
  etcpasswd << entry
end

Dir["/home/*"].each do |homedir|
  etcpasswd.each do |entry|
    if homedir == entry.dir
      home_users[homedir] = Mash.new(
                                      :username => entry.name,
                                      :gid      => entry.gid,
                                      :uid      => entry.uid,
                                      :gecos    => entry.gecos
                                     )
    end
  end
end
