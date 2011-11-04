#!/usr/bin/env perl
use strict;
use warnings;

use Calvie;

Calvie->new(schema_dsn => 'dbi:SQLite:calvie.db')->to_app;
