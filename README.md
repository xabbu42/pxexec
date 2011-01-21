
Description
-----------

pxexec is a tool to execute commands over the X11 protocol, inspired by [xexec](http://gpl.internetconnection.net/). I use pxexec to securely call local commands from a remote machine over X11 forwarding.

Installation
------------

pxexec is easiest to install with [cpanminus](http://search.cpan.org/~miyagawa/App-cpanminus-1.1006/lib/App/cpanminus.pm):

    cpanm https://github.com/downloads/xabbu42/pxexec/App-pxexec-0.2.tar.gz

If you want to install pxexec manually you can use the following commands:

    wget --no-check-certificate https://github.com/downloads/xabbu42/pxexec/App-pxexec-0.2.tar.gz
    tar -xzf App-pxexec-0.2.tar.gz
    cd App-pxexec-0.2
    perl Makefile.PL
    make
    sudo make install

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
- Consider supporting to stream output using [Coro](http://search.cpan.org/~mlehmann/Coro/). Currently all output is read in pxlisten and send to pxexec as one block. So you only see any output from pxexec after the command finished.

