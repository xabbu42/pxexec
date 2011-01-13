
package PXEXEC;

my @exports;
BEGIN {
	@exports = qw/set_property get_property remove_property wait_property/;
}
use Sub::Exporter -setup => {
	exports => \@exports, 
	groups  => { default => \@exports }
};

use X11::Protocol;
use YAML qw/Dump/;

my $x;
BEGIN {
	$x = X11::Protocol->new();
	die "Could not create x object" unless $x;
}

sub get_property {
	my ($prop) = @_;
	my ($value, $type, $format, $bytes_after) =
		$x->GetProperty($x->root, $x->atom($prop), $x->atom('STRING'), 0, -1, 0);
	return $value;
}

sub set_property {
	my ($prop, $value) = @_;
	$x->ChangeProperty($x->root, $x->atom($prop), $x->atom('STRING'), 8, 'Replace', $value)
}

sub remove_property {
	my ($prop) = @_;
	#$x->DeleteProperty($x->root, $x->atom($prop));
}

sub wait_property {
	my ($prop) = @_;
	$prop = qr/\Q$prop\E/ unless ref $prop;
	$x->ChangeWindowAttributes(
		$x->root,
		event_mask => $x->pack_event_mask('PropertyChange')
	);
	$x->{event_handler} = 'queue';
	my $e, $res, $name;
	while ($e = {$x->next_event}) {
		next unless $e->{state} eq "NewValue";
		$name = $x->atom_name($e->{atom});
		if ($name =~ $prop) {
			$res = $1 || $prop;
			last;
		}
	}
	return $e ? ($res, get_property($name)) : null;
}

1;
