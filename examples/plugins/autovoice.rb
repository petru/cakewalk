require 'cakewalk'

# Give this bot ops in a channel and it'll auto voice
# visitors
#
# Enable with !autovoice on
# Disable with !autovoice off

class Autovoice
  include Cakewalk::Plugin
  listen_to :join
  match /autovoice (on|off)$/

  def listen(m)
    unless m.user.nick == bot.nick
      m.channel.voice(m.user) if @autovoice
    end
  end

  def execute(m, option)
    @autovoice = option == "on"

    m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.nick            = "cakewalk_autovoice"
    c.server          = "irc.libera.chat"
    c.channels        = ["#cakewalk-bots"]
    c.verbose         = true
    c.plugins.plugins = [Autovoice]
  end
end

bot.start
