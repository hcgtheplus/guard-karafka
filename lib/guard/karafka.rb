# frozen_string_literal: true

require 'guard/compat/plugin'
require_relative "karafka/version"

module Guard
  class Karafka < Plugin

    DEFAULT_SIGNAL = :TERM

    def initialize(options = {})
    @options = options
    @pid = nil
    @stop_signal = options[:stop_signal] || DEFAULT_SIGNAL
    @options[:verbose] = @options.fetch(:verbose, true)
    super
    end

    def start
      Guard::Compat::UI.info 'Starting up karafka...'
      Guard::Compat::UI.info cmd

      @pid = spawn({}, cmd)
    end

    def stop
      if @pid
        Guard::Compat::UI.info 'Stopping karafka...'
        ::Process.kill @stop_signal, @pid
        begin
          Timeout.timeout(15) do
            ::Process.wait @pid
          end
        rescue Timeout::Error
          Guard::Compat::UI.info 'Sending SIGKILL to karafka, as it\'s taking too long to shutdown.'
          ::Process.kill :KILL, @pid
          ::Process.wait @pid
        end
        Guard::Compat::UI.info 'Stopped process karafka'
      end
    rescue Errno::ESRCH
      Guard::Compat::UI.info 'Guard::Karafka lost the karafka worker subprocess!'
    ensure
      @pid = nil
    end


    def reload
      Guard::Compat::UI.info 'Restarting karafka...'
      restart
    end

    def run_all
      true
    end

    # Called on file(s) modifications
    def run_on_changes(paths)
      restart
    end

    def restart
      stop
      start
    end

    def cmd
      command = ['bundle exec karafka server']

      command << "--require #{@options[:require]}" if @options[:require]
      command.join(' ')
    end
  end
end