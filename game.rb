class Game

    def initialize(away_team, home_team, away_team_hitters, away_team_pitchers, 
        home_team_hitters, home_team_pitchers, player_1, player_2)
        @away_team, @home_team = away_team, home_team
        @away_team_hitters, @home_team_hitters = away_team_hitters, home_team_hitters
        @away_team_pitchers, @home_team_pitchers = away_team_pitchers, away_team_pitchers
        @player_1, @player_2 = player_1, player_2
    end

    def play
        puts "Welcome to MLB 2 Player Game! The selected teams and players have been added."
        puts "For the pitching player, use the number keys to select pitch zone (i.e, 0 2 for top right corner)"
        puts "For the hitting player, follow the options given on the screen"
        puts "Type 's' and 'enter' to start game"
        selected_key = gets.chomp
        system("clear") if selected_key == "s"




    end
end