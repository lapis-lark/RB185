CREATE TABLE lists(
  id serial PRIMARY KEY,
  name text UNIQUE NOT NULL
);

CREATE TABLE todos(
  id serial PRIMARY KEY,
  name text NOT NULL,
  list_id integer references lists(id) ON DELETE CASCADE NOT NULL,
  completed bool NOT NULL DEFAULT false
);