require 'yaml'

config_file = ARGV.first
config = YAML::load File.open(config_file)

host = config['smtp']['server']['host']
port = config['smtp']['server']['port']
helo_domain = config['smtp']['server']['helo_domain']
tls = true == config['smtp']['tls']
unless config['smtp']['auth'].nil?
  auth_type = config['smtp']['auth']['type'].to_sym
  user = config['smtp']['auth']['user']
  pass = config['smtp']['auth']['pass']  
end

message_from = config['message']['from']
message_to = config['message']['to']

gem_outdated = IO.popen 'gem outdated'
lines = gem_outdated.readlines
gem_outdated.close

require 'net/smtp'

smtp_conn = Net::SMTP.new(host, port)
smtp_conn.enable_starttls if tls
smtp_conn.start(helo_domain, user, pass, auth_type)

require 'mail'

Mail.defaults do                                                   
  delivery_method :smtp_connection, { :connection => smtp_conn }   
end                

Mail.deliver do
   from message_from
   to message_to
   subject 'Outdated software packages'
   body lines
end
