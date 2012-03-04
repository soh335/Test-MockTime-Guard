#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Test::MockTime::Guard';
}

diag "Testing Test::MockTime::Guard/$Test::MockTime::Guard::VERSION";
