require 'open-uri'
require 'cakewalk'

class TinyURL
  include Cakewalk::Plugin

  listen_to :channel

  def shorten(url)
    url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
    url == "Error" ? nil : url
  rescue OpenURI::HTTPError
    nil
  end

  def listen(m)
    urls = URI.extract(m.message, "http")
    short_urls = urls.map { |url| shorten(url) }.compact
    unless short_urls.empty?
      m.reply short_urls.join(", ")
    end
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.libera.chat"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [TinyURL]
  end
end

bot.start
