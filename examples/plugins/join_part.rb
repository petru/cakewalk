require 'cakewalk'

class JoinPart
  include Cakewalk::Plugin

  match /join (.+)/, method: :join
  match /part(?: (.+))?/, method: :part

  def initialize(*args)
    super

    @admins = ["injekt", "DominikH"]
  end

  def check_user(user)
    user.refresh # be sure to refresh the data, or someone could steal
                 # the nick
    @admins.include?(user.authname)
  end

  def join(m, channel)
    return unless check_user(m.user)
    Channel(channel).join
  end

  def part(m, channel)
    return unless check_user(m.user)
    channel ||= m.channel
    Channel(channel).part if channel
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.libera.chat"
    c.nick   = "CakewalkBot"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [JoinPart]
  end
end

bot.start
