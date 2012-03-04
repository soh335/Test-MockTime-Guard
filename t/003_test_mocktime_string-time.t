use strict;
use warnings;

use Test::More;
use Test::MockTime::Guard;
use Time::Local();

# stolen from Test::MockTime test code

my $TRUE = Time::Local::timegm(19, 25, 3, 30, 6, 2006);

{
    # determine the correct epoch value for our test time

    # set_absolute_time with a defaulted date spec
    my $guard = mock_absolute_time_guard('2006-07-30T03:25:19Z');
    my $mock = time;
    ok(($mock >= $TRUE) && ($mock <= $TRUE+1), "Absolute time works");

    sleep 2;
    $mock = time;
    ok(($mock >= $TRUE+2) && ($mock <= $TRUE+3), "Absolute time is still in sync after two seconds sleep:$mock");

    $mock = Time::Local::timelocal(localtime);
    my $real = Time::Local::timelocal(CORE::localtime);
    ok($mock <= $real, "localtime seems ok");
}

{
  # set_absolute_time with an explicit date spec
  my $guard = mock_absolute_time_guard('03:25:19 07/30/2006', '%H:%M:%S %m/%d/%Y');
  my $mock = time;
  ok(($mock >= $TRUE) && ($mock <= $TRUE+1), "Absolute time with explicit date specworks");

  sleep 2;
  $mock = time;
  ok(($mock >= $TRUE+2) && ($mock <= $TRUE+3), "Absolute time is still in sync after two seconds sleep:$mock");

  my $real = Time::Local::timelocal(CORE::localtime);
  ok($mock <= $real, "localtime seems ok");
}
{
    # try set_fixed_time with a defaulted date spec
    my $guard1 = mock_fixed_time_guard('2006-07-30T03:25:19Z');
    my $real = time;
    sleep 2;
    my $mock = time;
    cmp_ok($mock, '==', $real, "time is fixed");
    cmp_ok($mock, '==', $TRUE, "time is fixed correctly");

    my $guard2 = mock_fixed_time_guard('2006-07-30T03:25:19Z');
    $mock = Time::Local::timelocal(localtime());
    sleep 2;
    $real = Time::Local::timelocal(localtime);
    cmp_ok($mock, '==', $real, "localtime is fixed");
    cmp_ok($mock, '==', $TRUE, "localtime is fixed correctly");

    my $guard3 = mock_fixed_time_guard('2006-07-30T03:25:19Z');
    $mock = Time::Local::timegm(gmtime);
    sleep 2;
    $real = Time::Local::timegm(gmtime);
    cmp_ok($mock, '==', $real, "gmtime is fixed");
    cmp_ok($mock, '==', $TRUE, "gmtime is fixed correctly");
}

{
    # try set_fixed_time with an explicit date spec
    my $guard1 = mock_fixed_time_guard('03:25:19 07/30/2006', '%H:%M:%S %m/%d/%Y');
    my $real = time;
    sleep 2;
    my $mock = time;
    cmp_ok($mock, '==', $real, "time is fixed with explicit date spec");
    cmp_ok($mock, '==', $TRUE, "time is fixed correctly");

    my $guard2 = mock_fixed_time_guard('03:25:19 07/30/2006', '%H:%M:%S %m/%d/%Y');
    $mock = Time::Local::timelocal(localtime());
    sleep 2;
    $real = Time::Local::timelocal(localtime);
    cmp_ok($mock, '==', $real, "localtime is fixed");
    cmp_ok($mock, '==', $TRUE, "localtime is fixed correctly");

    my $guard3 = mock_fixed_time_guard('03:25:19 07/30/2006', '%H:%M:%S %m/%d/%Y');
    $mock = Time::Local::timegm(gmtime);
    sleep 2;
    $real = Time::Local::timegm(gmtime);
    cmp_ok($mock, '==', $real, "gmtime is fixed");
    cmp_ok($mock, '==', $TRUE, "gmtime is fixed correctly");
}

done_testing;
