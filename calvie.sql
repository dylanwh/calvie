create table calendar (
	id integer not null primary key,
	name text not null unique,
	realm text not null,
	url text not null,
	username text not null,
	password text not null
);
