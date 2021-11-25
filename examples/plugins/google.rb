require 'cakewalk'
require 'open-uri'
require 'nokogiri'
require 'cgi'

class Google
  include Cakewalk::Plugin
  match /google (.+)/

  def search(query)
    url = "http://www.google.com/search?q=#{CGI.escape(query)}"
    res = Nokogiri.parse(open(url).read).at("h3.r")

    title = res.text
    link = res.at('a')[:href]
    desc = res.at("./following::div").children.first.text
    CGI.unescape_html "#{title} - #{desc} (#{link})"
  rescue
    "No results found"
  end

  def execute(m, query)
    m.reply(search(query))
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.nick   = "MrCakewalk"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [Google]
  end
end

bot.start
