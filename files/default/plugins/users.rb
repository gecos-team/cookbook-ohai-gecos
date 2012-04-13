provides 'users'

require 'etc'

users Array.new

# LikeWise create the user homes at /home/local/DOMAIN/
homedirs = Dir["/home/*"] + Dir["/home/local/*/*"]
homedirs.each do |homedir|
  temp=homedir.split('/')
  user=temp[temp.size()-1]
  begin
    entry=Etc.getpwnam(user)
    users << Mash.new(
      :username => entry.name,
      :home     => entry.dir,
      :gid      => entry.gid,
      :uid      => entry.uid
    )
  rescue Exception => e
    puts 'User ' + user + ' doesn\'t exists'
  end
end
