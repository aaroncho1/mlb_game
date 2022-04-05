class Display

    BASE_LINE_WIDTH = 22
    PITCH_BOX_WIDTH = 11
    attr_accessor :bases

    def initialize
        @bases = []
    end

    def show_pitch_options
    end

    def move_players(bases, player)
        bases.unshift(player)
        (bases - 1).times {bases.unshift("empty")}
    end

    def show_bases_and_score(away_team, home_team, inning_half, inning)
        bases.each_with_index do |player, i|
            if i == 0
                player.is_a?(Hitter) ? puts "#{"1st base: #{player.name}".ljust(BASE_LINE_WIDTH)} #{away_team.name}:#{away_team.runs}" : puts "#{"1st base: empty".ljust(BASE_LINE_WIDTH)} #{away_team.name}:#{away_team.runs}"
            elsif i == 1
                player.is_a?(Hitter) ? puts "#{"2nd base: #{player.name}".ljust(BASE_LINE_WIDTH)} #{home_team.name}:#{home_team.runs}" : puts "#{"2nd base: empty".ljust(BASE_LINE_WIDTH)} #{home_team.name}:#{home_team.runs}"
            elsif i == 2
                player.is_a?(Hitter) ? puts "#{"3rd base: #{player.name}".ljust(BASE_LINE_WIDTH)} #{inning_half} #{inning}" : puts "#{"3rd base: empty".ljust(BASE_LINE_WIDTH)} #{inning_half} #{inning}"
            end
        end
    end 

    def render(pitcher, hitter, away_team, home_team, inning, 
        inning_half, inning_outs, balls, strikes, strike_zone)
        show_bases_and_score(away_team, home_team, inning_half, inning)
        puts "#{balls}-#{strikes}, #{inning_outs} outs"
        puts ""
        strike_zone.each do |row|
            puts row.join(" ").ljust(PITCH_BOX_WIDTH)
        end
        puts ""
        puts "At bat: #{hitter.name} (#{hitter.hits}-#{hitter.at_bats},#{hitter.homers} HR #{hitter.rbis} RBI"
        puts "Pitching: #{pitcher.name} (#{pitcher.pitches} P, #{pitcher.earned_runs} ER)"
        puts "Select Pitch:"
        pitcher.pitch_options.each do |num, pitch|
            puts "#{num}- #{pitch}"
        end
        puts "Pitch strike %"
        pitcher.tendencies.each do |pitch, tend|
            pitch_percentage = tend[:S] / (tend[:S] + tend[:B])
            puts "#{pitch}-#{pitch_percentage}%"
        end
    end
end