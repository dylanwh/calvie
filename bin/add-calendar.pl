#!/usr/bin/env perl
use strict;
use warnings;

use Calvie;

my $schema = Calvie->new(schema_dsn => 'dbi:SQLite:calvie.db')->schema;

my $name = $schema->add_calendar(@ARGV);

print "list name is $name\n";
