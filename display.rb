class Display

    BASE_LINE_WIDTH = 22
    PITCH_BOX_WIDTH = 11
    attr_reader :plays, :pitch_sequence
    attr_accessor :bases

    def initialize
        @bases = ["empty", "empty", "empty"]
        @plays = []
        @pitch_sequence = []
    end

    def move_players(result, player)
        bases.unshift(player)
        (result - 1).times {bases.unshift("empty")} if result > 1
    end

    def show_bases_and_score(away_team, home_team, inning_half, inning)
        bases.each_with_index do |player, i|
            if i == 0
                if player.is_a?(Hitter)
                    puts "#{"1st base: #{player.name}".ljust(BASE_LINE_WIDTH)} #{away_team.name}:#{away_team.runs}" 
                else 
                    puts "#{"1st base: empty".ljust(BASE_LINE_WIDTH)} #{away_team.name}:#{away_team.runs}"
                end
            elsif i == 1
                if player.is_a?(Hitter) 
                    puts "#{"2nd base: #{player.name}".ljust(BASE_LINE_WIDTH)} #{home_team.name}:#{home_team.runs}" 
                else 
                    puts "#{"2nd base: empty".ljust(BASE_LINE_WIDTH)} #{home_team.name}:#{home_team.runs}"
                end
            elsif i == 2
                if player.is_a?(Hitter)
                    puts "#{"3rd base: #{player.name}".ljust(BASE_LINE_WIDTH)} #{inning_half} #{inning}"
                else 
                    puts "#{"3rd base: empty".ljust(BASE_LINE_WIDTH)} #{inning_half} #{inning}"
                end
            end
        end
    end 

    def pitch_count_and_outs(balls, strikes, inning_outs)
        puts ""
        puts "#{balls}-#{strikes}, #{inning_outs} outs"
    end

    def show_strike_zone(current_pitch, strike_zone)
        puts ""
        puts "#{"".ljust(PITCH_BOX_WIDTH)} Last pitch:"
        strike_zone.each do |row|
            puts "#{" ".ljust(PITCH_BOX_WIDTH)} #{row.join(" ")}"
        end
    end

    def show_pitcher_and_batter(hitter, pitcher)
        puts ""
        puts "At bat: #{hitter.name} (#{hitter.hits}-#{hitter.at_bats},#{hitter.homers} HR #{hitter.rbis} RBI)"
        puts "Pitching: #{pitcher.name} (#{pitcher.pitches} P, #{pitcher.earned_runs} ER, Stamina: #{pitcher.stamina / 2})"
    end

    def show_pitch_selection_and_percentage(pitcher)
        puts ""
        puts "#{"Select Pitch:".ljust(BASE_LINE_WIDTH)} Strike %:" 
        pitcher.pitch_options.each do |num, pitch|
            pitch_percentage = pitcher.tendencies[pitch][:S] * 10
            puts "#{"#{num}- #{pitch}".ljust(BASE_LINE_WIDTH)} #{pitch_percentage}%"
        end
    end

    #Pitcher.new("G. Cole", "A+", tendencies = {:fastball => {:S => 8, :B => 2}, :slider => {:S => 7, :B => 3}, :curveball => {:S => 5, :B => 5}, 
    #:changeup => {:S => 5, :B => 5}}, 2, pitch_options = {1 => :fastball, 2 => :slider, 3 => :curveball, 4 => :changeup})

    def show_pitch_sequence
        puts ""
        puts "Pitch sequence:"
        pitch_sequence.each_with_index do |pitch, i|
            puts "#{i + 1}: #{pitch}"
        end
    end

    def show_plays
        puts ""
        puts "Inning summary:"
        plays.each do |play|
            puts play
        end
    end

    def render(pitcher, hitter, away_team, home_team, inning, inning_half, 
        inning_outs, balls, strikes, strike_zone, current_pitch)
        show_bases_and_score(away_team, home_team, inning_half, inning)
        pitch_count_and_outs(balls, strikes, inning_outs)
        show_strike_zone(current_pitch, strike_zone)
        show_pitcher_and_batter(hitter, pitcher)
        show_pitch_selection_and_percentage(pitcher)
        show_pitch_sequence
        show_plays
    end
end