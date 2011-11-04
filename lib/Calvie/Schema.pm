package Calvie::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-11-04 15:40:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0X2noTpDOaZAAQodFCgv9g

use Digest::MD5 ();

sub add_calendar {
    my ($self, $url, $realm, $username, $password) = @_;

    my $cal = $self->resultset('Calendar');
    my $name = Digest::MD5::md5_hex(
        join('', map { Digest::MD5::md5_hex($_) } $username, $password, $url, $realm)
    );

    $cal->find_or_create( { name => $name, realm => $realm, url => $url, username => $username, password => $password } );

    return $name;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
