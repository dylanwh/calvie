package Calvie;
use OX;
use namespace::autoclean;

use Moose::Util::TypeConstraints 'class_type';
BEGIN { class_type 'Calvie::Schema' };

has 'schema_args' => (
    is    => 'ro',
    isa   => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'schema_dsn' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'schema' => (
    is    => 'ro',
    isa   => 'Calvie::Schema',
    block => sub {
        my $s = shift;

        Calvie::Schema->connect(
            $s->param('schema_dsn'),
            @{ $s->param('schema_args') },
        );
    },
    dependencies => [ 'schema_dsn', 'schema_args' ],
    lifecycle    => 'Singleton',
);

has 'user_agent' => (
    is    => 'ro',
    isa   => 'LWP::UserAgent',
    block => sub {
        my $s      = shift;
        my $schema = $s->param('schema');
        my $cal_rs = $schema->resultset('Calendar');

        my $ua = LWP::UserAgent->new;
        while ( my $cal = $cal_rs->next ) {
            my $uri = URI->new( $cal->url );
            $ua->credentials(
                join( ':', $uri->host, $uri->port ),
                $cal->realm,
                $cal->username,
                $cal->password,
            );
        }

        return $ua;
    },
    dependencies => ['schema'],
);

has 'list' => (
    is           => 'ro',
    isa          => 'Calvie::Controller::List',
    dependencies => [qw[ user_agent schema ]],
);

router as {
    route '/list/:name' => 'list';
};


__PACKAGE__->meta->make_immutable;

1;
