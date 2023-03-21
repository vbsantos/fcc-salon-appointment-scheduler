#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -c"

function printBlankLine () {
  printf "\n";
}

function show_title () {
  declare title=$1;
  echo "~~~~~ $title ~~~~~";
}

function get_services () {
  declare db_response=$($PSQL "SELECT service_id, name FROM services;");
  SERVICES=$(echo "$db_response" | sed '1,2d;$d');
}

function show_menu () {
  declare list="$1";
  
  while IFS= read -r line; do
    IFS='|' read -ra fields <<< "$line"
    declare id=$(echo "${fields[0]}" | xargs)
    declare name=$(echo "${fields[1]}" | xargs)
    echo "$id) $name"
  done <<< "$list"
}

function get_service() {
  SERVICE_ID_SELECTED="$1";

  declare db_response=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;");
  SERVICE=$(echo "$db_response" | sed '1,2d;$d' | xargs);
  [[ "$SERVICE" == "" ]] && return "0" || return "$SERVICE_ID_SELECTED";
}

function get_customer_by_phone() {
  declare phone=$1
  
  declare db_response=$($PSQL "SELECT name FROM customers WHERE phone = '$phone';");
  declare name=$(echo "$db_response" | sed '1,2d;$d' | xargs);

  [[ "$name" == "" ]] && return "0" || return "$name"
}

function add_customer() {
  declare name="$1"
  declare phone="$2"

  declare db_response=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$name', '$phone');");
}

function get_customer_id_by_phone() {
  declare phone="$1"
  
  declare db_response=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$phone';");
  declare id=$(echo "$db_response" | sed '1,2d;$d' | xargs);

  return $id
}

function make_appointment() {
  declare phone="$1";

  get_customer_id_by_phone "$phone"
  declare customer_id="$?"

  declare db_response=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ('$customer_id','$SERVICE_ID_SELECTED','$SERVICE_TIME');");
}

function run () {
  declare title="VINI'S SALON";

  printBlankLine;
  show_title $title;
  printBlankLine;
  
  # set SERVICES variable
  get_services;
  echo "Welcome, how can I help you?";
  printBlankLine;

  while true; do
    show_menu "$SERVICES";
    printBlankLine;

    read SERVICE_ID_SELECTED;
    
    # set SERVICE variable
    get_service "$SERVICE_ID_SELECTED";

    if [ "$?" == "0" ]; then
      echo "I could not find that service. What would you like today?"
      printBlankLine;
      continue;
    else
      break;
    fi
  done

  echo "What's your phone number?"
  read CUSTOMER_PHONE;

  get_customer_by_phone "$CUSTOMER_PHONE"
  CUSTOMER_NAME="$?";

  if [ "$CUSTOMER_NAME" == "0" ]; then
    echo "I don't have a record for that phone number, what's your name"
    read CUSTOMER_NAME;
    # Insert new customer
    add_customer "$CUSTOMER_NAME" "$CUSTOMER_PHONE";
  fi


  echo "What time would you like your $SERVICE, $CUSTOMER_NAME?"
  read SERVICE_TIME;

  # Insert appointment
  make_appointment "$CUSTOMER_PHONE";

  echo "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

run;