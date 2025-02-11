require 'cakewalk'

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server   = "irc.libera.chat"
    c.nick     = "CakewalkBot"
    c.channels = ["#cakewalk-bots"]
  end

  on :message, /^!msg (.+?) (.+)/ do |m, who, text|
    User(who).send text
  end
end

bot.start

