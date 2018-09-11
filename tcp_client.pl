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

my $remote_host = $ARGV[0] // 'server';
my $remote_port = $ARGV[1] // 24000;

my $socket;

while (1) {
    $socket = IO::Socket::INET->new(PeerAddr => $remote_host,
                                    PeerPort => $remote_port,
                                    Proto    => "tcp",
                                    Type     => SOCK_STREAM);
    last if $socket;

    warn "Couldn't connect to $remote_host:$remote_port : $@ ... wait and retry\n";
    sleep 2;
}
    

my $delay = 1;
my $count = 0;
while (1) {
    $count++;
    my $now = localtime;
    my $msg = "PING ($count) at $now";
    say "";
    say "[@{[scalar localtime]}] send $msg";

    print $socket "$msg\n";

    my $answer = <$socket>;

    unless (defined $answer) {
        say "[@{[scalar localtime]}] FAILED TO RECEIVE ANSWER...QUIT";
        last;
    }
    
    chomp $answer;
    say "[@{[scalar localtime]}] recv $answer";

    say "[@{[scalar localtime]}]  sleep $delay secs";
    sleep $delay;
    $delay *= 2;
}

# and terminate the connection when we're done
close($socket)
