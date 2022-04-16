class Team 
    attr_reader :name, :hitters, :pitchers, :batting_order
    attr_accessor :runs

    def initialize(name, hitters, pitchers)
        @name = name 
        @hitters, @pitchers = hitters, pitchers
        @runs = 0
        @batting_order = hitters.dup
    end
end

