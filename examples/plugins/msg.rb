require 'cakewalk'

class Messenger
  include Cakewalk::Plugin

  match /msg (.+?) (.+)/
  def execute(m, receiver, message)
    User(receiver).send(message)
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.libera.chat"
    c.nick   = "CakewalkBot"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [Messenger]
  end
end

bot.start

