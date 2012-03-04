package Test::MockTime::Guard;

use strict;
use warnings;

use 5.008_001;

use Exporter qw/import/;
use Carp;

our $VERSION = '0.01';
our @EXPORT = qw/mock_fixed_time_guard mock_absolute_time_guard mock_relative_time_guard/;

my $count = 0;
my $time_map = {};

BEGIN {
    *CORE::GLOBAL::time      = \&Test::MockTime::Guard::time;
    *CORE::GLOBAL::gmtime    = \&Test::MockTime::Guard::gmtime;
    *CORE::GLOBAL::localtime = \&Test::MockTime::Guard::localtime;
}


sub mock_fixed_time_guard {
    my $time = _time(@_);
    Test::MockTime::Guard->new( fixed => $time, offset => 0 );
}

sub mock_absolute_time_guard {
    my $time = _time(@_);
    $time -= CORE::time;
    Test::MockTime::Guard->new( fixed => 0, offset => $time );
}

sub mock_relative_time_guard {
    my ($time) = @_;
    Test::MockTime::Guard->new( fixed => 0, offset => $time );
}

# stolen from Test::MockTime::_time
sub _time {
    my ($time, $spec) = @_;
    unless ($time =~ /\A -? \d+ \z/xms) {
        $spec ||= '%Y-%m-%dT%H:%M:%SZ';
    }
    if ($spec) {
        require Time::Piece;
        $time = Time::Piece->strptime($time, $spec)->epoch();
    }
    return $time;
}

sub new {
    my ($class, %args) = @_;

    $time_map->{$count} = {
        offset => $args{offset},
        fixed  => $args{fixed},
    };

    bless { count  => $count++ }, $class;
}

sub DESTROY {
    my ($self) = @_;

    #warn sprintf "start to destroy self:%d count:%d",  $self->{count}, $count;

    $count -= 1;
    delete $time_map->{$self->{count}};
}

sub time() {

    my $index = $count - 1;

    if ( $count > 0 ) {
        if ( $time_map->{$index}->{fixed} ) {
            return $time_map->{$index}->{fixed};
        }
        else {
            return CORE::time + $time_map->{$index}->{offset}
        }
    }
    else {
        return CORE::time;
    }
}

sub localtime(;$) {
    my ($time) = @_;

    unless ( defined $time) {
        $time = Test::MockTime::Guard::time();
    }

    CORE::localtime($time);
}

sub gmtime(;$) {
    my ($time) = @_;

    unless ( defined $time ) {
        $time = Test::MockTime::Guard::time();
    }

    CORE::gmtime($time);
}

1;

__END__

=head1 NAME

Test::MockTime::Guard - Perl extention to do something

=head1 VERSION

This document describes Test::MockTime::Guard version 0.01.

=head1 SYNOPSIS

    use Test::MockTime::Guard;

    {
        my $guard1 = mock_fixed_time_guard("2006-07-30T03:25:19Z");
        warn time();

        {
            my $guard2 = mock_fixed_time_guard("2006-08-30T03:25:19Z");
            warn time()
        }

        {
            my $guard3 = mock_absolute_time_guard("2006-09-30T03:25:19Z");
            warn time();
        }

        {
            my $guard4 = mock_relative_time_guard(-100);
        }
    }

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

<<YOUR NAME HERE>> E<lt><<YOUR EMAIL ADDRESS HERE>>E<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, <<YOUR NAME HERE>>. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
