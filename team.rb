class Team 
    attr_reader :name
    attr_accessor :hitters, :pitchers, :runs, :hits, :errors

    def initialize(name, hitters, pitchers)
        @name = name 
        @hitters = []
        @pitchers = []
        @runs = 0
        @hits = 0
        @errors = 0
    end
end

#hitter tendencies are out of 200 ABs
#In tendencies hash, 0 represents out, 1- singles, 2-doubles, 3-triples, 4-homers
mets_hitters = [
    Hitter.new("S. Marte", "CF", {0 => 138, 1 => 44, 2 => 12, 3 => 1, 4 => 5}, "A"),
    Hitter.new("B. Nimmo", "RF", {0 => 142, 1 => 42, 2 => 10, 3 => 1, 4 => 5}, "A"),
    Hitter.new("F. Lindor", "SS", {0 => 143, 1 => 32, 2 => 13, 3 => 1, 4 => 11}, "B"),
    Hitter.new("P. Alonso", "1B", {0 => 148, 1 => 23, 2 => 10, 3 => 1, 4 => 18}, "C"),
    Hitter.new("E. Esobar", "3B", {0 => 149, 1 => 30, 2 => 9, 3 => 2, 4 => 10}, "C"),
    Hitter.new("R. Cano", "DH", {0 => 149, 1 => 30, 2 => 14, 3 => 0, 4 => 7}, "D"),
    Hitter.new("J. McNeil", "2B", {0 => 150, 1 => 36, 2 => 9, 3 => 1, 4 => 4}, "B"),
    Hitter.new("J. McCann", "C", {0 => 158, 1 => 31, 2 => 6, 3 => 0, 4 => 5}, "C"),
    Hitter.new("M. Canha", "LF", {0 => 154, 1 => 28, 2 => 9, 3 => 2, 4 => 7}, "B")
]

Team.new("NYM", mets_hitters, mets_pitchers)