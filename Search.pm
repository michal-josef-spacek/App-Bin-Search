package App::Bin::Search;

use strict;
use warnings;

use Bit::Vector;
use Getopt::Std;

our $VERSION = 0.01;

$| = 1;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Object.
	return $self;
}

# Run.
sub run {
	my $self = shift;

	# Process arguments.
	$self->{'_opts'} = {
		'h' => 0,
		'v' => 0,
	};
	if (! getopts('hv', $self->{'_opts'}) || @ARGV < 2
		|| $self->{'_opts'}->{'h'}) {

		print STDERR "Usage: $0 [-h] [-v] [--version] hex_stream search\n";
		print STDERR "\t-h\t\tPrint help.\n";
		print STDERR "\t-v\t\tVerbose mode.\n";
		print STDERR "\t--version\tPrint version.\n";
		print STDERR "\thex_stream\tInput hexadecimal stream.\n";
		print STDERR "\tsearch\t\tSearch string (in hex).\n";
		return 1;
	}
	$self->{'_hex_stream'} = $ARGV[0];
	$self->{'_search'} = $ARGV[1];

	$self->{'_bv'} = Bit::Vector->new_Hex(
		length($self->{'_hex_stream'}) * 4,
		$self->{'_hex_stream'},
	);

	my $processed_bits = 0;
	if ($self->{'_opts'}->{'v'}) {
		print 'Size of hexadecimal stream: '.$self->{'_bv'}->Size."\n";
	}
	foreach (1 .. $self->{'_bv'}->Size) {
		$processed_bits++;
		my $tmp = $self->{'_bv'}->Clone;
		$tmp->Resize($self->{'_bv'}->Size - $processed_bits);
		if ($tmp->to_Hex =~ m/^$self->{'_search'}/ms) {
			print 'Found '.$tmp->to_Hex.' at '.$processed_bits." bit\n";
		} else {
			if ($self->{'_opts'}->{'v'}) {
				print $tmp->to_Hex.' at '.$processed_bits."bit \n";
			}
		}
		$self->{'_bv'}->Move_Left(1);
	}

	return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Bin::Search - Base class for bin-search tool.

=head1 SYNOPSIS

 use App::Bin::Search;

 my $app = App::Bin::Search->new;
 my $exit_code = $app->run;

=head1 METHODS

=head2 C<new>

 my $app = App::Bin::Search->new;

Constructor.

Returns instance of object.

=head2 C<run>

 my $exit_code = $app->run;

Run.

Returns 1 for error, 0 for success.

=head1 EXAMPLE

=for comment filename=bin_search.pl

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

=head1 DEPENDENCIES

L<Bit::Vector>,
L<Getopt::Std>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/App-Bin-Search>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
