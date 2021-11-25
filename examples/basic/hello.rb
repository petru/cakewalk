require 'cakewalk'

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#cakewalk-bots"]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
end

bot.start

