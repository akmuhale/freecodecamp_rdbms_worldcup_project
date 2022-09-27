#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
  then
    # get team_id(TEAMS) of winner
    WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $WINNER_TEAM_ID ]]
    then
      # insert team_id(TEAMS) of winner and opponent in TEAMS
      insert_status="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      echo Inserted into TEAMS, $WINNER
      #get team_id(winner)
      WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi
    if [[ -z $OPPONENT_TEAM_ID  ]]
    then
      # insert team_id(TEAMS) of winner and opponent in TEAMS
      insert_status="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      echo Inserted into TEAMS, $OPPONENT
      #get team_id(opponent)
      OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi
    # insert in games (game_id,year,round,winner_id,opponent_id,winner_goals,opponent_goals)
    INSERT_GAMES_DETAIL="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND','$WINNER_TEAM_ID','$OPPONENT_TEAM_ID','$WINNER_GOALS','$OPPONENT_GOALS')")"
    echo $INSERT_GAMES_DETAIL
  fi 
done

