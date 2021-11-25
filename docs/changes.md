# @title What has changed?
# @markup kramdown

# What has changed in 2.2?

## Getting rid of CP1252 in favour of UTF-8

In versions before 2.2, when using the `irc` encoding (the default),
Cakewalk would use CP1252 for outgoing messages, only falling back to
UTF-8 if a message wouldn't fit into CP1252. This is a so called
hybrid encoding, which is used by X-Chat and the like.

This encoding, however, is based on the state of 10 years ago, where
the most popular IRC clients, such as mIRC, weren't capable of
handling UTF-8. Nowadays, there are more clients that support UTF-8
than there are clients that can deal with this hybrid encoding, or
CP1252 itself. That's why, from now on, we will always use UTF-8.

If you depend on outgoing messages being encoded in CP1252, please see
{file:docs/encodings.md} on how to change the encoding.

## API improvements

### New methods

- {Cakewalk::Channel#remove} has been added to support the non-standard
REMOVE command, a friendlier alternative to kicking people.

- {Cakewalk::Helpers.sanitize} and {Cakewalk::Formatting.unformat} have been
  added to help with removing unprintable characters and mIRC
  formatting codes from strings.

### Deprecated methods

In order to reduce the amount of aliases, the following ones have been
deprecated and will be removed in a future release:

- {Cakewalk::Channel#msg}
- {Cakewalk::Channel#privmsg}
- {Cakewalk::Target#msg}
- {Cakewalk::Target#privmsg}
- {Cakewalk::Target#safe_msg}
- {Cakewalk::Target#safe_privmsg}
- {Cakewalk::User#whois}
- {Cakewalk::Helpers#Color}

Additionally, the following method is deprecated and will be removed
in the future:

- {Cakewalk::Channel#to_str}

# What has changed in 2.1?
1. Color stripping
1. Per group hooks
1. API improvements
   1. New methods
   1. Changed methods
   1. New aliases

## Color stripping

The new method <del>`Cakewalk::Utilities::String.strip_colors`</del>
{Cakewalk::Formatting.unformat} allows removal of mIRC color codes from
messages.

Additionally, a new match option called `strip_colors` makes it
possible to automatically and temporarily strip color codes before
attempting to match a message.

## Per group hooks

A new option `group` for hooks allows registering hooks for specific
groups.

## API improvements

### New methods

#### {Cakewalk::Bot}

- {Cakewalk::Bot#oper}

#### {Cakewalk::User}

- {Cakewalk::User#oper?}

#### {Cakewalk::Message}

- {Cakewalk::Message#action_reply}
- {Cakewalk::Message#safe_action_reply}

### Changed methods

#### {Cakewalk::Handler}

- {Cakewalk::Handler#call} now returns the started thread.

#### {Cakewalk::HandlerList}

- {Cakewalk::HandlerList#dispatch} now returns the started threads.

### New aliases

Due to some unfortunate naming mistakes in Cakewalk 2.0, Cakewalk 2.1 adds
several aliases. All of the new aliases deprecate the original method
names, which will be removed in Cakewalk 3.0.

#### {Cakewalk::User}
- {Cakewalk::User#monitored?} for {Cakewalk::User#monitored}
- {Cakewalk::User#synced?} for {Cakewalk::User#synced}



# What has changed in 2.0?
1. Added support for SASL
1. Added support for DCC SEND
1. Added a fair scheduler for outgoing messages
1. Added required plugin options
1. Added support for colors/formatting
1. Added network discovery
1. Added match groups
1. Added match options overwriting plugin options
1. Added support for actions (/me)
1. Added support for broken IRC networks
1. Dynamic timers
1. Reworked logging facilities
1. API improvements
   1. Helper changes
   1. Added a Cakewalk::Target Target class
   1. Cakewalk::Constants
   1. New methods
   1. Removed/Renamed methods
   1. Handlers
   1. The Plugin class
   1. Channel/Target/User implement Comparable
   1. Renamed `*Manager` to `*List`
1. New events

## Added support for SASL

Cakewalk now supports authenticating to services via SASL. For more
information check {Cakewalk::SASL}.

## Added support for DCC SEND

Support for sending and receiving files via DCC has been added to
Cakewalk. Check {Cakewalk::DCC} for more information.

## Added a fair scheduler for outgoing messages
Cakewalk always provided sophisticated throttling to avoid getting kicked
due to _excess flood_. One major flaw, however, was that it used a
single FIFO for all messages, thus preferring early message targets
and penalizing later ones.

Now Cakewalk uses a round-robin approach, having one queue per message
target (channels and users) and one for generic commands.

## Added required plugin options

Plugins can now require specific options to be set. If any of those
options are not set, the plugin will automatically refuse being
loaded.

This is useful for example for plugins that require API keys to
interact with web services.

The new attribute is called
{Cakewalk::Plugin::ClassMethods#required_options required_options}.

Example:

    class MyPlugin
      include Cakewalk::Plugin

      set :required_options, [:foo, :bar]
      # ...
    end

    # ...

    bot.configure do |c|
      c.plugins.plugins = [MyPlugin]
      c.plugins.options[MyPlugin] = {:foo => 1}
    end

    # The plugin won't load because the option :bar is not set.
    # Instead it will print a warning.

## Added support for colors/formatting

A new {Cakewalk::Formatting module} and {Cakewalk::Helpers#Format helper}
for adding colors and formatting to messages has been added. See the
{Cakewalk::Formatting module's documentation} for more information on
usage.

## Added support for network discovery

Cakewalk now tries to detect the network it connects to, including the
running IRCd. For most parts this is only interesting internally, but
if you're writing advanced plugins that hook directly into IRC and
needs to be aware of available features/quirks, check out
{Cakewalk::IRC#network} and {Cakewalk::Network}.

## Reworked logging facilities

The logging API has been drastically improved. Check the
{file:docs/logging.md logging documentation} for more information.


## Added match groups

A new option for matchers, `:group`, allows grouping multiple matchers
to a group. What's special is that in any group, only the first
matching handler will be executed.

Example:

    class Foo
      include Cakewalk::Plugin

      match /foo (\d+)/, group: :blegh, method: :foo1
      match /foo (.+)/,  group: :blegh, method: :foo2
      match /foo .+/,                   method: :foo3
      def foo1(m, arg)
        m.reply "foo1"
      end

      def foo2(m, arg)
        m.reply "foo2"
      end

      def foo3(m)
        m.reply "foo3"
      end
    end
    # 02:05:39       dominikh │ !foo 123
    # 02:05:40          cakewalk │ foo1
    # 02:05:40          cakewalk │ foo3

    # 02:05:43       dominikh │ !foo bar
    # 02:05:44          cakewalk │ foo2
    # 02:05:44          cakewalk │ foo3


## Added match options overwriting plugin options

Matchers now have their own `:prefix`, `:suffix` and `:react_on`
options which overwrite plugin options for single matchers.


## Added support for actions (/me)

A new event, {`:action`} has been added and can be used for matching
actions as follows:

    match "kicks the bot", react_on: :action
    def execute(m)
      m.reply "Ouch!"
    end

## API improvements

### Helper changes

The helper methods {Cakewalk::Helpers#User User()} and
{Cakewalk::Helpers#Channel Channel()} have been extracted from
{Cakewalk::Bot} and moved to {Cakewalk::Helpers their own module} which can
be reused in various places.

### Added a {Cakewalk::Target Target} class

Since {Cakewalk::Channel} and {Cakewalk::User} share one common interface
for sending messages, it only makes sense to have a common base class.
{Cakewalk::Target This new class} takes care of sending messages and
removes this responsibility from {Cakewalk::Channel}, {Cakewalk::User} and
{Cakewalk::Bot}

### {Cakewalk::Constants}

All constants for IRC numeric replies (`RPL_*` and `ERR_*`) have been
moved from {Cakewalk} to {Cakewalk::Constants}

### New methods

#### {Cakewalk::Bot}

- {Cakewalk::Bot#channel_list}
- {Cakewalk::Bot#handlers}
- {Cakewalk::Bot#loggers}
- {Cakewalk::Bot#loggers=}
- {Cakewalk::Bot#modes}
- {Cakewalk::Bot#modes=}
- {Cakewalk::Bot#set_mode}
- {Cakewalk::Bot#unset_mode}
- {Cakewalk::Bot#user_list}

#### {Cakewalk::Channel}

- {Cakewalk::Channel#admins}
- {Cakewalk::Channel#half_ops}
- {Cakewalk::Channel#ops}
- {Cakewalk::Channel#owners}
- {Cakewalk::Channel#voiced}

#### {Cakewalk::Helpers}

- {Cakewalk::Helpers#Target} -- For creating a {Cakewalk::Target Target} which can receive messages
- {Cakewalk::Helpers#Timer}  -- For creating new timers anywhere
- {Cakewalk::Helpers#rescue_exception} -- For rescueing and automatically logging an exception
- {Cakewalk::Helpers#Format} -- For adding colors and formatting to messages

##### Logging shortcuts
- {Cakewalk::Helpers#debug}
- {Cakewalk::Helpers#error}
- {Cakewalk::Helpers#exception}
- {Cakewalk::Helpers#fatal}
- {Cakewalk::Helpers#incoming}
- {Cakewalk::Helpers#info}
- {Cakewalk::Helpers#log}
- {Cakewalk::Helpers#outgoing}
- {Cakewalk::Helpers#warn}

#### {Cakewalk::IRC}

- {Cakewalk::IRC#network}

#### {Cakewalk::Message}

- {Cakewalk::Message#action?}
- {Cakewalk::Message#action_message}
- {Cakewalk::Message#target}
- {Cakewalk::Message#time}

#### {Cakewalk::Plugin}

- {Cakewalk::Plugin#handlers}
- {Cakewalk::Plugin#timers}
- {Cakewalk::Plugin#unregister}

#### {Cakewalk::User}

- {Cakewalk::User#away}
- {Cakewalk::User#dcc_send} - See {Cakewalk::DCC::Outgoing::Send}
- {Cakewalk::User#match}
- {Cakewalk::User#monitor} - See {file:docs/common_tasks.md#checking-if-a-user-is-online Checking if a user is online}
- {Cakewalk::User#monitored}
- {Cakewalk::User#online?}
- {Cakewalk::User#unmonitor}

### Handlers

Internally, Cakewalk uses {Cakewalk::Handler Handlers} for listening to and
matching events. In previous versions, this was hidden from the user,
but now they're part of the public API, providing valuable information
and the chance to {Cakewalk::Handler#unregister unregister handlers}
alltogether.

{Cakewalk::Bot#on} now returns the created handler and
{Cakewalk::Plugin#handlers} allows getting a plugin's registered
handlers.

### Removed/Renamed methods
The following methods have been removed:

| Removed method                         | Replacement                                                                     |
|----------------------------------------+---------------------------------------------------------------------------------|
| Cakewalk::Bot#halt                        | `next` or `break` (Ruby keywords)                                               |
| Cakewalk::Bot#raw                         | {Cakewalk::IRC#send}                                                               |
| Cakewalk::Bot#msg                         | {Cakewalk::Target#msg}                                                             |
| Cakewalk::Bot#notice                      | {Cakewalk::Target#notice}                                                          |
| Cakewalk::Bot#safe_msg                    | {Cakewalk::Target#safe_msg}                                                        |
| Cakewalk::Bot#safe_notice                 | {Cakewalk::Target#safe_notice}                                                     |
| Cakewalk::Bot#action                      | {Cakewalk::Target#action}                                                          |
| Cakewalk::Bot#safe_action                 | {Cakewalk::Target#safe_action}                                                     |
| Cakewalk::Bot#dispatch                    | {Cakewalk::HandlerList#dispatch}                                                   |
| Cakewalk::Bot#register_plugins            | {Cakewalk::PluginList#register_plugins}                                            |
| Cakewalk::Bot#register_plugin             | {Cakewalk::PluginList#register_plugin}                                             |
| Cakewalk::Bot#logger                      | {Cakewalk::Bot#loggers}                                                            |
| Cakewalk::Bot#logger=                     |                                                                                 |
| Cakewalk::Bot#debug                       | {Cakewalk::LoggerList#debug}                                                       |
| Cakewalk::IRC#message                     | {Cakewalk::IRC#send}                                                               |
| Cakewalk::Logger::Logger#log_exception    | {Cakewalk::Logger#exception}                                                       |
| Class methods in Plugin to set options | A new {Cakewalk::Plugin::ClassMethods#set set} method as well as attribute setters |


### The Plugin class

The {Cakewalk::Plugin Plugin} class has been drastically improved to look
and behave more like a proper Ruby class instead of being some
abstract black box.

All attributes of a plugin (name, help message, matchers, …) are being
made available via attribute getters and setters. Furthermore, it is
possible to access a Plugin instance's registered handlers and timers,
as well as unregister plugins.

For a complete overview of available attributes and methods, see
{Cakewalk::Plugin} and {Cakewalk::Plugin::ClassMethods}.

### Plugin options

The aforementioned changes also affect the way plugin options are
being set: Plugin options aren't set with DSL-like methods anymore but
instead are made available via {Cakewalk::Plugin::ClassMethods#set a
`set` method} or alternatively plain attribute setters.

See
{file:docs/migrating.md#plugin-options the migration guide} for more
information.

### Channel/Target/User implement Comparable

{Cakewalk::Target} and thus {Cakewalk::Channel} and {Cakewalk::User} now
implement the Comparable interface, which makes them sortable by all
usual Ruby means.

### Renamed `*Manager` to `*List`

`Cakewalk::ChannelManager` and `Cakewalk::UserManager` have been renamed to
{Cakewalk::ChannelList} and {Cakewalk::UserList} respectively.

## Added support for broken IRC networks
Special support for the following flawed IRC networks has been added:

- JustinTV
- NGameTV
- IRCnet

## Dynamic timers

It is now possible to create new timers from any method/handler. It is
also possible to {Cakewalk::Timer#stop stop existing timers} or
{Cakewalk::Timer#start restart them}.

The easiest way of creating new timers is by using the
{Cakewalk::Helpers#Timer Timer helper method}, even though it is also
possible, albeit more complex, to create instances of {Cakewalk::Timer}
directly.

Example:

    match /remind me in (\d+) seconds/
    def execute(m, seconds)
      Timer(seconds.to_i, shots: 1) do
        m.reply "This is your reminder.", true
      end
    end

For more information on timers, see the {Cakewalk::Timer Timer documentation}.

## New options

- :{file:docs/bot_options.md#dccownip dcc.own_ip}
- :{file:docs/bot_options.md#modes modes}
- :{file:docs/bot_options.md#maxreconnectdelay max_reconnect_delay}
- :{file:docs/bot_options.md#localhost local_host}
- :{file:docs/bot_options.md#delayjoins delay_joins}
- :{file:docs/bot_options.md#saslusername sasl.username}
- :{file:docs/bot_options.md#saslpassword sasl.password}

## New events
- :{file:docs/events.md#action action}
- :{file:docs/events.md#away away}
- :{file:docs/events.md#unaway unaway}
- :{file:docs/events.md#dccsend dcc_send}
- :{file:docs/events.md#owner owner}
- :{file:docs/events.md#dehalfop-deop-deowner-devoice deowner}
- :{file:docs/events.md#leaving leaving}
- :{file:docs/events.md#online online}
- :{file:docs/events.md#offline offline}


# What has changed in 1.1?
1. **New events**
2. **New methods**
3. **New options**
4. **Improved logger**
x. **Deprecated methods**

## New events

- :{file:docs/events.md#op op}
- :{file:docs/events.md#dehalfop-deop-deowner-devoice deop}
- :{file:docs/events.md#voice voice}
- :{file:docs/events.md#dehalfop-deop-deowner-devoice devoice}
- :{file:docs/events.md#halfop halfop}
- :{file:docs/events.md#dehalfop-deop-deowner-devoice dehalfop}
- :{file:docs/events.md#ban ban}
- :{file:docs/events.md#unban unban}
- :{file:docs/events.md#modechange mode_change}
- :{file:docs/events.md#catchall catchall}

Additionally, plugins are now able to send their own events by using
Cakewalk::Bot#dispatch.

## New methods

### {Cakewalk::User#last_nick}
Stores the last nick of a user. This can for example be used in `on
:nick` to compare a user's old nick against the new one.

### Cakewalk::User#notice, Cakewalk::Channel#notice and Cakewalk::Bot#notice
For sending notices.

### {Cakewalk::Message#to_s}
Provides a nicer representation of {Cakewalk::Message} objects.

### {Cakewalk::Channel#has_user?}
Provides an easier way of checking if a given user is in a channel

## New options
- {file:docs/bot_options.md#pluginssuffix plugins.suffix}
- {file:docs/bot_options.md#ssluse ssl.use}
- {file:docs/bot_options.md#sslverify ssl.verify}
- {file:docs/bot_options.md#sslcapath ssl.ca_path}
- {file:docs/bot_options.md#sslclientcert ssl.client_cert}
- {file:docs/bot_options.md#nicks nicks}
- {file:docs/bot_options.md#timeoutsread timeouts.read}
- {file:docs/bot_options.md#timeoutsconnect timeouts.connect}
- {file:docs/bot_options.md#pinginterval ping_interval}
- {file:docs/bot_options.md#reconnect reconnect}



## Improved logger
The {Cakewalk::Logger::FormattedLogger formatted logger} (which is the
default one) now contains timestamps. Furthermore, it won't emit color
codes if not writing to a TTY.

Additionally, it can now log any kind of object, not only strings.

## Deprecated methods

| Deprecated method           | Replacement                        |
|-----------------------------+------------------------------------|
| Cakewalk::User.find_ensured    | Cakewalk::UserManager#find_ensured    |
| Cakewalk::User.find            | Cakewalk::UserManager#find            |
| Cakewalk::User.all             | Cakewalk::UserManager#each            |
| Cakewalk::Channel.find_ensured | Cakewalk::ChannelManager#find_ensured |
| Cakewalk::Channel.find         | Cakewalk::ChannelManager#find         |
| Cakewalk::Channel.all          | Cakewalk::ChannelManager#each         |
