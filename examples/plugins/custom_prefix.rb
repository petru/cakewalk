require 'cakewalk'

class SomeCommand
  include Cakewalk::Plugin

  set :prefix, /^~/
  match "somecommand"

  def execute(m)
    m.reply "Successful"
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server   = "irc.libera.chat"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [SomeCommand]
  end
end

bot.start

