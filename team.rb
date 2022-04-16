class Team 
    attr_reader :name, :hitters, :pitchers
    attr_accessor :runs

    def initialize(name, hitters, pitchers)
        @name = name 
        @hitters, @pitchers = hitters, pitchers
        @runs = 0
    end
end

