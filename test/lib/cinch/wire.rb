require "helper"

class WireTest < TestCase
  def setup
    @bot = Cakewalk::Bot.new do
      self.loggers.clear
      @irc = Cakewalk::IRC.new(self)
      @irc.setup
      @name = "cakewalk"
      # stub these so that they work without a real server connection
      def user
        "test"
      end
      def host
        "testhost"
      end
    end
    # put a StringIO in place of a socket
    @io = StringIO.new
    @bot.irc.instance_variable_set(:@socket, @io)
    @queue = Cakewalk::MessageQueue.new(@io, @bot)
    @bot.irc.instance_variable_set(:@queue, @queue)
    @to_process = @queue.instance_variable_get(:@queues_to_process)
  end

  # return all the data sent over the wire
  def sent
    while !@to_process.empty?
      @queue.__send__(:process_one)
    end
    @io.rewind
    @io.read
  end

  test "should be able to inspect sent IRC commands in tests" do
    @bot.send("hello,")
    @bot.send("world!")
    assert_equal "PRIVMSG cakewalk :hello,\r\nPRIVMSG cakewalk :world!\r\n", sent
  end

  test "should not be able to inject IRC commands using newlines in actions" do
    @bot.action("evil\r\nKICK #testchan John :Injecting commands")
    assert_equal "PRIVMSG cakewalk :\001ACTION evil\001\r\n", sent
  end

  test "should not be able to send more than one IRC command at a time" do
    @bot.irc.send("first\r\nsecond")
    assert_equal "first\r\n", sent
  end

end

