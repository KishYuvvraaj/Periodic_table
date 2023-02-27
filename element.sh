#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t -c"


if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
exit
fi

if [[ $1 =~ ^[1-9]+$ ]]
then
  Element_info=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = '$1'")
else
  Element_info=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1'")
fi


if [[ -z $Element_info ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $Element_info | while IFS=" |" read ATNO NAME SYMBOL TYPE ATMASS MELTPT BOILPT
do
  echo -e "The element with atomic number $ATNO is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATMASS amu. $NAME has a melting point of $MELTPT celsius and a boiling point of $BOILPT celsius."
done
