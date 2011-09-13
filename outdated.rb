gem_outdated = IO.popen 'gem outdated'
lines = gem_outdated.readlines
gem_outdated.close

smtp_conn = Net::SMTP.new('smtp.gmail.com', 587)
smtp_conn.enable_starttls
smtp_conn.start('smtp.gmail.com', 'user', 'pass', :plain)

Mail.defaults do                                                   
  delivery_method :smtp_connection, { :connection => smtp_conn }   
end                

#Mail.deliver do
#   from 'from'
#   to 'to'
#   subject 'Outdated software packages'
#   body lines
#end

#TODO: smtp configuration stuff
