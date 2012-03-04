use strict;
use warnings;

use Test::More;
use Test::MockTime::Guard;

# stolen from Test::MockTime test code

my $guard2 = mock_fixed_time_guard(2);

my $four = time + 2;
is($four, 4, "time() does not try so slurp any arguments");

my @arr    = (0, 1, 2);
my $got    = localtime @arr;
my $expect = localtime scalar @arr;
is($got, $expect, "localtime() treats its argument as an expression");

$got    = gmtime @arr;
$expect = gmtime scalar @arr;
is($got, $expect, "gmtime() treats its argument as an expression");

done_testing;
