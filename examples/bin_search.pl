#!/usr/bin/env perl

use strict;
use warnings;

use App::Bin::Search;

# Arguments.
@ARGV = (
        'FFABCD',
        'D5',
);

# Run.
exit App::Bin::Search->new->run;

# Output like:
# TODO