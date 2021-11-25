Cakewalk - The IRC Bot Building Framework
=====================================

**The Cakewalk project is no longer maintained. No new features will be
added, and no bugs will be fixed. The repository has been archived. If
you wish to continue developing Cakewalk, please fork the project. I am
not accepting new maintainers for this project.**

Description
-----------

Cakewalk is an IRC Bot Building Framework for quickly creating IRC bots in
Ruby with minimal effort. It provides a simple interface based on plugins and
rules. It's as easy as creating a plugin, defining a rule, and watching your
profits flourish.

Cakewalk will do all of the hard work for you, so you can spend time creating cool
plugins and extensions to wow your internet peers.

For general support, join #cakewalk channel on Freenode server (irc://irc.freenode.org/cakewalk) – but
please don't bring any bots.

Installation
------------

### RubyGems

You can install the latest Cakewalk gem using RubyGems

```
gem install cakewalk
```

### GitHub

Alternatively you can check out the latest code directly from Github

```
git clone http://github.com/cakewalkrb/cakewalk.git
```

Example
-------

Your typical Hello, World application in Cakewalk would go something like this:

```ruby
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
```

More examples can be found in the `examples` directory.

Features
--------

### Documentation

Cakewalk provides a documented API, which is online for your viewing pleasure
[here](http://rubydoc.info/gems/cakewalk/frames).

### Object Oriented

Many IRC bots (and there are, **so** many) are great, but we see so little of
them take advantage of the awesome Object Oriented Interface which most Ruby
programmers will have become accustomed to and grown to love.

Well, Cakewalk uses this functionality to its advantage. Rather than having to
pass around a reference to a channel or a user, to another method, which then
passes it to another method (by which time you're confused about what's
going on) -- Cakewalk provides an OOP interface for even the simpliest of tasks,
making your code simple and easy to comprehend.

### Threaded

Unlike a lot of popular IRC frameworks, Cakewalk is threaded. But wait, don't let
that scare you. It's totally easy to grasp.

Each of Cakewalk's plugins and handlers are executed in their own personal thread.
This means the main thread can stay focused on what it does best, providing
non-blocking reading and writing to an IRC server. This will prevent your bot
from locking up when one of your plugins starts doing some intense operations.
Damn that's handy.

### Plugins

That's right folks, Cakewalk provides a modular based plugin system. This is a
feature many people have bugged us about for a long time. It's finally here,
and it's as awesome as you had hoped!

This system allows you to create feature packed plugins without interfering with
any of the Cakewalk internals. Everything in your plugin is self contained, meaning
you can share your favorite plugins among your friends and release a ton of
your own plugins for others to use

Want to see the same Hello, World application in plugin form? Sure you do!

```ruby
require 'cakewalk'

class Hello
  include Cakewalk::Plugin

  match "hello"

  def execute(m)
    m.reply "Hello, #{m.user.nick}"
  end
end

bot = Cakewalk::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#cakewalk-bots"]
    c.plugins.plugins = [Hello]
  end
end

bot.start
```

Note: Plugins take a default prefix of `/^!/` which means the actual match is `!hello`.

More information can be found in the {Cakewalk::Plugin} documentation.

### Numeric Replies

Do you know what IRC code 401 represents? How about 376? or perhaps 502?
Sure you don't (and if you do, you're as geeky as us!). Cakewalk doesn't expect you
to store the entire IRC RFC code set in your head, and rightfully so!

That's exactly why Cakewalk has a ton of constants representing these numbers
so you don't have to remember them. We're so nice.

### Pretty Output

Ever get fed up of watching those boring, frankly unreadable lines
flicker down your terminal screen whilst your bot is online? Help is
at hand! By default, Cakewalk will colorize all text it sends to a
terminal, meaning you get some pretty damn awesome readable coloured
text. Cakewalk also provides a way for your plugins to log custom
messages:

```ruby
on :message, /hello/ do |m|
  debug "Someone said hello"
end
```

Contribute
----------

Love Cakewalk? Love Ruby? Love helping? Of course you do! If you feel like Cakewalk
is missing that awesome jaw-dropping feature and you want to be the one to
make this magic happen, you can!

Please note that although we very much appreciate all of your efforts, Cakewalk
will not accept patches in aid of Ruby 1.8 compatibility. We have no intention
of supporting Ruby versions below 1.9.1.

Fork the project, implement your awesome feature in its own branch, and send
a pull request to one of the Cakewalk collaborators. We'll be more than happy
to check it out.
