use strict;
use warnings;

use Test::More;
use Test::MockTime::Guard;
use Time::Local;

{
    my $true1 = Time::Local::timegm(19, 25, 3, 30, 6, 2006);
    my $guard1 = mock_fixed_time_guard("2006-07-30T03:25:19Z");

    my $mock = time;
    cmp_ok($mock, "==", $true1);

    {
        my $true2 = Time::Local::timegm(19, 25, 3, 30, 7, 2006);
        my $guard2 = mock_fixed_time_guard("2006-08-30T03:25:19Z");
        my $mock = time;
        cmp_ok($mock, "==", $true2);
    }

    $mock = time;
    cmp_ok($mock, "==", $true1);

    my $true3 = Time::Local::timegm(19, 25, 3, 30, 5, 2006);
    my $guard3 = mock_fixed_time_guard("2006-06-30T03:25:19Z");
    $mock = time;
    cmp_ok($mock, "==", $true3);
}

done_testing;
