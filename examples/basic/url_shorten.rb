require 'open-uri'
require 'cakewalk'

# Automatically shorten URL's found in messages
# Using the tinyURL API

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server   = "irc.libera.chat"
    c.channels = ["#cakewalk-bots"]
  end

  helpers do
    def shorten(url)
      url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
      url == "Error" ? nil : url
    rescue OpenURI::HTTPError
      nil
    end
  end

  on :channel do |m|
    urls = URI.extract(m.message, "http")

    unless urls.empty?
      short_urls = urls.map {|url| shorten(url) }.compact

      unless short_urls.empty?
        m.reply short_urls.join(", ")
      end
    end
  end
end

bot.start
