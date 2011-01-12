
pxexec
======

Description
-----------

pxexec is a tool to execute commands over the X11 protocol, inspired by [xexec](http://gpl.internetconnection.net/). I use pxexec to securely call local commands from a remote machine over X11 forwarding.

Usage
-----

    localhost:~ $ echo foobar > gna
	localhost:~ $ pxlisten &
	localhost:~ $ ssh -X otherhost
	otherhost:~ $ pxexec cat gna
	foobar
	otherhost:~

To start pxlisten automatically when starting your X session, add `pxlisten &` to your ~/.xinitrc, or use `pxlisten -v 2> pxlisten.log &` to get a log file with the executed commands.

Example Script for Emacs
------------------------

    #!/usr/bin/env perl
    use strict;
    use warnings;

    use File::Spec::Functions qw/rel2abs/;

    if ($ENV{'SSH_CLIENT'}) {
    	my $host = `uname -n`;
    	chomp $host;
    	system 'pxexec', 'emacsclient', '-c', map {
    		$_ = "/" . $host . ":" . rel2abs($_) unless $_ =~ /^-/;
    		$_;
    	} @ARGV;
    } else {
    	system 'emacsclient', '-c', @ARGV;
    }

Todos and Ideas
---------------

This is not a roadmap.

- Implement configurable restrictions to what commands can be executed.
- Avoid eval of arbitrary strings for security (this only makes sense after restrictions are implemented).
- Consider supporting to stream output using [Coro](http://search.cpan.org/~mlehmann/Coro/). Currently all output is read in pxlisten and send to pxexec as one block. So you only see any output from pxexec after the command finished.
- Add usage and some standard command line options to the tools.
- Consider using X11::Protocol instead of xprop

