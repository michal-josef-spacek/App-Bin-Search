use strict;
use warnings;

use App::Bin::Search;
use English;
use File::Object;
use File::Spec::Functions qw(abs2rel);
use Test::More 'tests' => 2;
use Test::NoWarnings;
use Test::Output;

# Test.
@ARGV = (
	'-h',
);
my $script = abs2rel(File::Object->new->file('04-run.t')->s);
# XXX Hack for missing abs2rel on Windows.
if ($OSNAME eq 'MSWin32') {
	$script =~ s/\\/\//msg;
}
my $right_ret = <<"END";
Usage: $script [-b] [-h] [-v] [--version] hex_stream search
	-b		Print in binary (default hexadecimal).
	-h		Print help.
	-v		Verbose mode.
	--version	Print version.
	hex_stream	Input hexadecimal stream.
	search		Search string (in hex).
END
stderr_is(
	sub {
		App::Bin::Search->new->run;
		return;
	},
	$right_ret,
	'Run help.',
);
