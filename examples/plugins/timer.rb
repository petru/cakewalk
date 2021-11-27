require 'cakewalk'

class TimedPlugin
  include Cakewalk::Plugin

  timer 5, method: :timed
  def timed
    Channel("#cakewalk-bots").send "5 seconds have passed"
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.nick            = "cakewalk_timer"
    c.server          = "irc.libera.chat"
    c.channels        = ["#cakewalk-bots"]
    c.verbose         = true
    c.plugins.plugins = [TimedPlugin]
  end
end

bot.start
