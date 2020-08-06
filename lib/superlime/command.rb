module Superlime
  class Command
    def self.call(args)
      catch(:broadcast) do
        new(args).call
      end
    end

    def initialize(*args)
      raise NotImplementedError, "must implement #initialize on subclass"
    end

    def call
      raise NotImplementedError, "must implement #call on subclass"
    end

    private

    def broadcast(event, payload)
      throw(:broadcast, event => payload)
    end
  end
end