# @title Migration Guide
# @markup kramdown

# Migration Guide

This document explains how to migrate between API incompatible
versions of Cakewalk.

## Migrating from 1.x to 2.x

## Plugins

### New methods

Plugins have the following (new) instance and class methods, which you
shouldn't and usually mustn't overwrite:

- `#bot`
- `#config`
- `#handlers`
- `#synchronize`
- `#timers`
- `#unregister`
- `::call_hooks`
- `::check_for_missing_options`
- `::ctcp`
- `::ctcps`
- `::help=`
- `::help`
- `::hook`
- `::hooks`
- `::listen_to`
- `::listeners`
- `::match`
- `::matchers`
- `::plugin_name=`
- `::plugin_name`
- `::prefix=`
- `::prefix`
- `::react_on=`
- `::react_on`
- `::required_options=`
- `::required_options`
- `::set`
- `::suffix=`
- `::suffix`
- `::timer`
- `::timers`

Note: The list does also include methods from prior versions.


### Plugin options

Previously, plugins used a DSL-like way of setting options like the
plugin prefix. This contradicts with the general idea of plugins being
ordinary Ruby classes and also caused a lot of code and documentation
smell.

Instead of having methods like `#prefix` double as both attribute
getter and setter, options can now be set in two different ways: Using
ordinary attribute setters or using the
{Cakewalk::Plugin::ClassMethods#set #set} method.

#### Cakewalk 1.x

    class MyPlugin
      include Cakewalk::Plugin

      prefix /^!/
      help "some help message"
      match /foo/
      def execute(m)
        # ...
      end
    end

#### Cakewalk 2.x, attribute setters

    class MyPlugin
      include Cakewalk::Plugin

      self.prefix = /^!/
      self.help   = "some help message"
      match /foo/
      def execute(m)
        # ...
      end
    end

#### Cakewalk 2.x, `#set` method

    class MyPlugin
      include Cakewalk::Plugin

      set :prefix, /^!/
      set :help,   "some help message"
      match /foo/
      def execute(m)
        # ...
      end
    end

#### Cakewalk 2.x, `#set` method, alternative syntax

    class MyPlugin
      include Cakewalk::Plugin

      set prefix: /^!/,
          help:   "some help message"
      match /foo/
      def execute(m)
        # ...
      end
    end


### No more automatic matcher with the plugin's name

Cakewalk does not add a default matcher with the plugin's name anymore.
If you've been relying on the following to work

    class Footastic
      include Cakewalk::Plugin

      def execute(m)
        # this will triger on "!footastic"
      end
    end

you will have to rewrite it using an explicit matcher:

    class Footastic
      include Cakewalk::Plugin

      match "footastic"
      def execute(m)
        # ...
      end
    end

### No more default `#execute` and `#listen` methods

Plugins do not come with default `#execute` and `#listen` methods
anymore, which means that specifying a matcher or listener without
providing the required methods will always result in an exception.

### Programmatically registering plugins

If you're using the API to register plugins on your own, you will have
to use the new {Cakewalk::PluginList} class and its methods, instead of
using `Cakewalk::Bot#register_plugin` or `Cakewalk::Bot#register_plugins`,
which have been removed.

The PluginList instance is available via {Cakewalk::Bot#plugins}.

## Logging

Logging in Cakewalk 2.x has been greatly improved. Instead of only
supporting one logger and having all logging-relevant methods in
{Cakewalk::Bot}, we've introduced the {Cakewalk::LoggerList} class, which
manages an infinite number of loggers. Included with Cakewalk are the
{Cakewalk::Logger::FormattedLogger formatted logger}, known from Cakewalk
1.x, and a new {Cakewalk::Logger::ZcbotLogger Zcbot logger}, a logger
emulating the log output of Zcbot, a format which can be parsed by
{http://pisg.sourceforge.net/ pisg}.

### Log levels

The old `@config.verbose` option has been replaced with a finely
tunable log level system. Each logger has {Cakewalk::Logger#level its own
level}, but it is also possible to {Cakewalk::LoggerList#level= set the
level for all loggers at once}.

The available levels, in ascending order of verbosity, are:

- fatal
- error
- warn
- info
- log
- debug

### Methods

All logging related methods (`Cakewalk::Bot#debug` et al) have been
removed from the Bot class and instead moved to the loggers and the
{Cakewalk::LoggerList LoggerList}. If you want to log messages from your
plugins or handlers, you should use {Cakewalk::Bot#loggers} to access the
{Cakewalk::LoggerList LoggerList} and then call the right methods on
that. Alterntively you can also use the logging-related helper methods
provided by {Cakewalk::Helpers}.

For more information on the logging architecture as well as examples
on how to use it, check the {file:docs/logging.md Logging readme}.

## Prefix/suffix + string semantics

Behaviour of string prefixes and suffixes has been adapted to match
that of matchers.

That means that if the prefix or suffix are strings, the ^ or $ anchor
will be prepended/appened.

## Hooks and their return value

Hooks now behave as filters. If a hook returns `false`, the message
will not further be processed in a particular plugin.

## Constants

All constants for numeric replies (e.g. `RPL_INFO`) have been moved from
{Cakewalk} to {Cakewalk::Constants}. Thus `Cakewalk::RPL_INFO` becomes
{Cakewalk::Constants::RPL_INFO}, same for all other numeric constants.

## Bot configuration

Bot configuration now uses {Cakewalk::Configuration special classes}
instead of OpenStructs. Thus, assignments like

    configure do |c|
      c.timeouts = OpenStruct.new({:read => 240, :connect => 10})
    end

are not possible anymore and have to be written as either

    configure do |c|
      c.timeouts.read    = 240
      c.timeouts.connect = 10
    end

or

    configure do |c|
      c.timeouts.load({:read => 240, :connect => 10})
    end

The second version is especially interesting to tools like
{https://github.com/netfeed/cakewalkize Cakewalkize}, which load the
configuration from a YAML file. For more information see
{file:docs/bot_options.md Bot options}.


## Various removed methods

See {file:docs/changes.md#removedrenamed-methods What's changed}


## `on`-handlers now only accepts one pattern

In previous versions, {Cakewalk::Bot#on} accepted a variable amount of patterns
to match against. This feature was rarely used and has hence been
removed. If you've been using constructs like

    on :message, [/this/, /that/] do |m|
      # ...
    end

you will have to rewrite them as follows:

    b = lambda { |m|
      # ...
    }

    [/this/, /that/].each do |pattern|
      on :message, pattern, &b
    end
