require 'cakewalk'

class RandomNumberGenerator
  def initialize(bot)
    @bot = bot
  end

  def start
    while true
      sleep 5 # pretend that we are waiting for some kind of entropy
      @bot.handlers.dispatch(:random_number, nil, Kernel.rand)
    end
  end
end

class DoSomethingRandom
  include Cakewalk::Plugin

  listen_to :random_number
  def listen(m, number)
    Channel("#cakewalk-bots").send "I got a random number: #{number}"
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.nick            = "cakewalk_events"
    c.server          = "irc.freenode.org"
    c.channels        = ["#cakewalk-bots"]
    c.verbose         = true
    c.plugins.plugins = [DoSomethingRandom]
  end
end


Thread.new { RandomNumberGenerator.new(bot).start }
bot.start
