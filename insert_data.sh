#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "truncate table games,teams restart identity"
tail -n +2 games.csv | while IFS=',' read -r year round winner opponent wg og
do 
$PSQL "insert into teams(name) values('$winner') on conflict do nothing"
$PSQL "insert into teams(name) values('$opponent') on conflict do nothing"
winner_id=$($PSQL "select team_id from teams where name='$winner'")
opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
$PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year,'$round',$winner_id,$opponent_id,$wg,$og)"
done