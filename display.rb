require "colorize"
require_relative 'hitter'

class Display
    BASE_LINE_WIDTH = 22
    PITCH_BOX_WIDTH = 11
    PLAYER_COL_WIDTH = 20
    STAT_COL_WIDTH = 4
    attr_accessor :bases, :plays, :pitch_sequence, :inning_runs, :play_by_play

    def initialize
        @bases = ["empty", "empty", "empty"]
        @plays = []
        @pitch_sequence = []
        @inning_runs = []
        @play_by_play = []
    end

    def add_runs_to_inning(runs)
        inning_runs << runs
    end

    def add_plays_to_play_by_play
        plays.each do |play|
            play_by_play << play
        end
    end

    def display_play_by_play
        system("clear")
        puts "-" * 16 + "PLAY BY PLAY SUMMARY" + "-" * 16
        play_by_play.each do |play|
            color_options = colors_for(play)
            puts play.to_s.colorize(color_options)
        end
    end

    def display_runs_summary(innings_played, away_team, home_team)
        system("clear")
        puts "-" * 20 + "GAME SUMMARY" + "-" * 20
        all_innings = (1..innings_played).to_a.join(" ")
        puts "      #{all_innings[0...-1]}   R H"
        away_team_runs = []
        home_team_runs = []
        away_team_hits = away_team.hitters.map{|away_hitter| away_hitter.hits}.sum
        home_team_hits = home_team.hitters.map{|home_hitter| home_hitter.hits}.sum
        @inning_runs.each_with_index {|runs, i| i.even? ? away_team_runs << runs : home_team_runs << runs}
        home_team_runs << " " if home_team_runs.length != innings_played - 1     
        puts "#{away_team.name}   #{away_team_runs.join(" ")}    #{away_team_runs.select{|num| num.is_a?(Integer)}.sum} #{away_team_hits}"
        puts "#{home_team.name}   #{home_team_runs.join(" ")}    #{away_team_runs.select{|num| num.is_a?(Integer)}.sum} #{home_team_hits}"
    end

    def display_box_score(away, home)
        puts "-" * 21 + "BOX SCORE" + "-" * 22
        puts "#{"Batters - #{away.name}".ljust(PLAYER_COL_WIDTH)} #{"AB".ljust(STAT_COL_WIDTH)} #{"H".ljust(STAT_COL_WIDTH)} #{"HR".ljust(STAT_COL_WIDTH)} #{"RBI".ljust(STAT_COL_WIDTH)} #{"BB".ljust(STAT_COL_WIDTH)}"
        away.batting_order.each do |player|
            puts "#{"#{player.name} #{player.position}".ljust(PLAYER_COL_WIDTH)} #{player.at_bats.to_s.ljust(STAT_COL_WIDTH)} #{player.hits.to_s.ljust(STAT_COL_WIDTH)} #{player.homers.to_s.ljust(STAT_COL_WIDTH)} #{player.rbis.to_s.ljust(STAT_COL_WIDTH)} #{player.walks.to_s.ljust(STAT_COL_WIDTH)}"
        end 
        puts ""
        puts "#{"Batters - #{home.name}".ljust(PLAYER_COL_WIDTH)} #{"AB".ljust(STAT_COL_WIDTH)} #{"H".ljust(STAT_COL_WIDTH)} #{"HR".ljust(STAT_COL_WIDTH)} #{"RBI".ljust(STAT_COL_WIDTH)} #{"BB".ljust(STAT_COL_WIDTH)}"
        home.batting_order.each do |player|
            puts "#{"#{player.name} #{player.position}".ljust(PLAYER_COL_WIDTH)} #{player.at_bats.to_s.ljust(STAT_COL_WIDTH)} #{player.hits.to_s.ljust(STAT_COL_WIDTH)} #{player.homers.to_s.ljust(STAT_COL_WIDTH)} #{player.rbis.to_s.ljust(STAT_COL_WIDTH)} #{player.walks.to_s.ljust(STAT_COL_WIDTH)}"
        end
    end

    def first_base_open?
        bases[0] == "empty"
    end

    def man_on_first?
        bases[0].is_a?(Hitter) && bases[1] == "empty" && bases[2] == "empty"
    end

    def men_on_first_and_second?
        bases[0].is_a?(Hitter) && bases[1].is_a?(Hitter) && bases[2] == "empty"
    end

    def men_on_corners?
        bases[0].is_a?(Hitter) && bases[1] == "empty" && bases[2].is_a?(Hitter)
    end

    def bases_loaded?
        bases[0..2].all?{|player| player.is_a?(Hitter)}
    end

    def runner_on_base?
        bases[0..2].any?{|base| base.is_a?(Hitter)}
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
        puts "#{"".ljust(PITCH_BOX_WIDTH - 2)} Last pitch:"
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
            color_options = colors_for(play)
            puts play.to_s.colorize(color_options)
        end
    end

    def colors_for(play)
        if play.include?("scored")
            color = :green 
        elsif play.include?("out")
            color = :red  
        end
        { color: color }
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