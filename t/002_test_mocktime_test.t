use strict;
use warnings;

use Test::More;
use Test::MockTime::Guard;
use Time::Local();

# stolen from Test::MockTime test code

{
    my $mock = time;
    my $real = CORE::time;

    ok(($mock == $real) || (($mock + 1) == $real) || (($mock - 1) == $real), "Starting time " . localtime($mock)); # previous two statements might go over a second boundary
}

{
    my $guard = mock_relative_time_guard(-600);
    sleep 2;

    my $mock = time;
    $mock += 600;
    my $real = CORE::time;
    ok(($mock == $real) || (($mock + 1) == $real) || (($mock - 1) == $real), "Set time to be 10 minutes ago, slept for two seconds, time was still in sync");

    $mock = Time::Local::timelocal(localtime);
    $real = Time::Local::timelocal(CORE::localtime);
    $mock = $mock + 600;
ok(($mock == $real) || (($mock + 1) == $real) || (($mock - 1) == $real), "localtime was also still in sync");

}

{
    my $guard = mock_relative_time_guard(+2);

    sleep 2;
    my $mock = time;
    my $real = CORE::time;
    ok($mock >= ($real + 1), "Set time to be 2 seconds in the future, slept for three seconds, time was still in front");

    $mock = Time::Local::timelocal(localtime);
    $real = Time::Local::timelocal(CORE::localtime);

    ok($mock >= ($real + 1), "localtime was also still in front");
}

{
    my $guard = mock_absolute_time_guard(100);

    my $mock = time;

    ok(($mock >= 100) && ($mock <= 101), "Absolute time works");

    sleep 2;
    $mock = time;
    ok(($mock >= 102) && ($mock <= 103), "Absolute time is still in sync after two seconds sleep:$mock");

    $mock = Time::Local::timelocal(localtime);
    my $real = Time::Local::timelocal(CORE::localtime);
    ok($mock <= $real, "localtime seems ok");
}

{
    my $guard1 = mock_fixed_time_guard( CORE::time );

    my $real = time;
    sleep 2;
    my $mock = time;
    ok($mock == $real, "fixed time correctly");

    my $guard2 = mock_fixed_time_guard( CORE::time );
    $mock = Time::Local::timelocal(localtime());
    sleep 2;
    $real = Time::Local::timelocal(localtime);
    ok($mock eq $real, "fixed localtime correctly");

    my $guard3 = mock_fixed_time_guard( CORE::time );
    $mock = Time::Local::timegm(gmtime);
    sleep 2;
    $real = Time::Local::timegm(gmtime);
    ok($mock eq $real, "fixed gmtime correctly");
}



done_testing;
