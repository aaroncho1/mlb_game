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
#for example, Aaron Judge is projected to hit 14 * 3 = 42 HRs in 600 ABs and batting (200 - 143 outs) 57/ 200 = .285
mets_hitters = [
    Hitter.new("S. Marte", "CF", {0 => 138, 1 => 44, 2 => 12, 3 => 1, 4 => 5}, "A"),
    Hitter.new("B. Nimmo", "RF", {0 => 142, 1 => 42, 2 => 10, 3 => 1, 4 => 5}, "A"),
    Hitter.new("F. Lindor", "SS", {0 => 143, 1 => 32, 2 => 13, 3 => 1, 4 => 11}, "B"),
    Hitter.new("P. Alonso", "1B", {0 => 148, 1 => 24, 2 => 12, 3 => 1, 4 => 15}, "C"),
    Hitter.new("E. Esobar", "3B", {0 => 149, 1 => 30, 2 => 9, 3 => 2, 4 => 10}, "C"),
    Hitter.new("R. Cano", "DH", {0 => 149, 1 => 30, 2 => 14, 3 => 0, 4 => 7}, "D"),
    Hitter.new("J. McNeil", "2B", {0 => 150, 1 => 36, 2 => 9, 3 => 1, 4 => 4}, "B"),
    Hitter.new("J. McCann", "C", {0 => 158, 1 => 31, 2 => 6, 3 => 0, 4 => 5}, "C"),
    Hitter.new("M. Canha", "LF", {0 => 154, 1 => 28, 2 => 9, 3 => 2, 4 => 7}, "B")
]

yankees_hitters = [
    Hitter.new("D. LeMahieu", "2B", {0 => 135, 1 => 45, 2 => 11, 3 => 1, 4 => 8}, "B"),
    Hitter.new("A. Rizzo", "1B", {0 => 150, 1 => 32, 2 => 8, 3 => 1, 4 => 9}, "C"),
    Hitter.new("A. Judge", "RF", {0 => 143, 1 => 34, 2 => 9, 3 => 0, 4 => 14}, "B"),
    Hitter.new("G. Stanton", "DH", {0 => 145, 1 => 33, 2 => 8, 3 => 0, 4 => 14}, "C"),
    Hitter.new("G. Torres", "SS", {0 => 148, 1 => 38, 2 => 10, 3 => 0, 4 => 4}, "C"),
    Hitter.new("J. Donaldson", "3B", {0 => 150, 1 => 27, 2 => 12, 3 => 0, 4 => 11}, "C"),
    Hitter.new("J. Gallo", "LF", {0 => 162, 1 => 10, 2 => 14, 3 => 0, 4 => 14}, "C"),
    Hitter.new("A. Hicks", "CF", {0 => 153, 1 => 27, 2 => 9, 3 => 0, 4 => 11}, "B"),
    Hitter.new("K. Higashioka", "C", {0 => 164, 1 => 16, 2 => 10, 3 => 0, 4 => 10}, "C")
]