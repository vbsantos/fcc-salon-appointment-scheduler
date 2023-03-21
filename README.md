# Commands

## Create your database by logging in to psql with 

```bash
psql --username=freecodecamp --dbname=postgres
```

## You can query the database in your script with

```bash
psql --username=freecodecamp --dbname=salon -c "<query>"
```

## You can make a dump of it by entering

```bash
pg_dump -cC --inserts -U freecodecamp salon > salon.sql
```

## You can rebuild the database by entering

```bash
psql -U postgres < salon.sql
```

## Create Database

```sql
CREATE DATABASE salon;

\connect salon

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR UNIQUE,
  name VARCHAR
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR
);


CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id SERIAL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  service_id SERIAL,
  FOREIGN KEY (service_id) REFERENCES services(service_id),
  time VARCHAR
);
```

## Populate Database

> You should have at least three rows in your services table for the different services you offer, one with a service_id of 1

```sql
INSERT INTO
  services (name)
VALUES
  ('Haircut and Style'),
  ('Hair Color and Highlights'),
  ('Perm and Straightening'),
  ('Blowout and Updo'),
  ('Keratin Treatment and Conditioning'),
  ('Manicure and Pedicure'),
  ('Acrylic Nails and Gel Polish');
```
