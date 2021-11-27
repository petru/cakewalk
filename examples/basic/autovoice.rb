require 'cakewalk'

# Give this bot ops in a channel and it'll auto voice
# visitors
#
# Enable with !autovoice on
# Disable with !autovoice off
#
# It starts out disabled.

bot = Cakewalk::Bot.new do
  configure do |c|
    c.nick            = "cakewalk_autovoice"
    c.server          = "irc.libera.chat"
    c.verbose         = true
    c.channels        = ["#cakewalk-bots"]
  end

  on :join do |m|
    unless m.user.nick == bot.nick # We shouldn't attempt to voice ourselves
      m.channel.voice(m.user) if @autovoice
    end
  end

  on :channel, /^!autovoice (on|off)$/ do |m, option|
    @autovoice = option == "on"

    m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
  end
end

bot.start
