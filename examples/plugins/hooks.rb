# -*- coding: utf-8 -*-
require 'cakewalk'

class HooksDemo
  include Cakewalk::Plugin

  hook :pre, method: :generate_random_number
  def generate_random_number(m)
    # Hooks are called in the same thread as the handler and thus
    # using thread local variables is possible.
    Thread.current[:rand] = Kernel.rand
  end

  hook :post, method: :cheer
  def cheer(m)
    m.reply "Yay, I successfully ran a command…"
  end

  match "rand"
  def execute(m)
    m.reply "Random number: " + Thread.current[:rand].to_s
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.nick            = "cakewalk_hooks"
    c.server          = "irc.freenode.org"
    c.channels        = ["#cakewalk-bots"]
    c.verbose         = true
    c.plugins.plugins = [HooksDemo]
  end
end


bot.start
