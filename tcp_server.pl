use strict;
use warnings;
use IO::Socket;
use 5.010;

$| = 1;

$SIG{TERM} = sub {
    say "[@{[scalar localtime]}] >>> recv SIGTERM <<<";
    exit;
};
$SIG{INT} = sub {
    say "[@{[scalar localtime]}] >>> recv SIGINT <<<";
    exit;
};


my $server_port = $ARGV[0] // 24000;

my $server = IO::Socket::INET->new(LocalPort => $server_port,
                                Type      => SOCK_STREAM,
                                Reuse     => 1,
                                Listen    => 10 )   # or SOMAXCONN
    or die "Couldn't be a tcp server on port $server_port : $@\n";

say "[@{[scalar localtime]}] server started at port $server_port...";

while (my $client = $server->accept()) {
    say "[@{[scalar localtime]}] NEW CONNECTION ESTABLISHED.";
    while (1) {
        my $read = <$client>;

        unless (defined $read) {
            say "[@{[scalar localtime]}] FAILED TO RECEIVE MESSAGE...QUIT";
            last;
        }

        chomp $read;
        say "[@{[scalar localtime]}] recv $read";
        my ($count) = $read =~ /\((\d+)\)/;

        print {$client} "PONG ($count)\n";
    }
}

close($server);
