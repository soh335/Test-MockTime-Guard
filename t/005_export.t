use strict;
use warnings;

use Test::More;
use Test::MockTime::Guard;

# stolen from Test::MockTime test code

eval{
    mock_relative_time_guard(1);
    mock_absolute_time_guard(2);
    mock_fixed_time_guard(3);
};
is( $@, q{}, 'export works' );

done_testing;
