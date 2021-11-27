require 'cakewalk'

class Hello
  include Cakewalk::Plugin

  match "hello"

  def execute(m)
    m.reply "Hello, #{m.user.nick}"
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.libera.chat"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [Hello]
  end
end

bot.start

