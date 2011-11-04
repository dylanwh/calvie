package Calvie::Controller::List;
use Moose;
use namespace::autoclean;

use HTTP::Throwable::Factory 'http_throw';

has 'schema' => (
    is       => 'ro',
    isa      => 'Calvie::Schema',
    required => 1,
    handles => { 'calendars' => [ 'resultset', 'Calendar'] },
);

has 'user_agent' => (
    is       => 'ro',
    isa      => 'LWP::UserAgent',
    required => 1,
);

sub get {
    my ($self, $r, $name) = @_;
    my $ua  = $self->user_agent;
    my $cal = $self->calendars->find({name => $name}) or http_throw('NotFound');

    my $cal_resp = $ua->get( $cal->url );

    return $r->new_response(
        $cal_resp->code,
        ['Content-Type' => $cal_resp->content_type],
        $cal_resp->content
    );
}

__PACKAGE__->meta->make_immutable;

1;
