use strict;
use warnings;
use Test::More 'no_plan';
use Mojo::UserAgent;
use Data::Dumper 'Dumper';
use Test::Exception;

BEGIN {
  use_ok('Mojo::Cloudstack') || print "Bail out!\n";
}

diag("Testing Mojo::Cloudstack $Mojo::Cloudstack::VERSION, Perl $], $^X");

my $cs = Mojo::Cloudstack->new(
  host       => "localhost",
  path       => "/client/api",
  port       => "8080",
  scheme     => "http",
  ua         => sub { Mojo::UserAgent->new },
);

dies_ok { $cs->api_key('doesnotexist') } 'file does not exist';
ok $cs->api_key('t/api_key');

dies_ok { $cs->secret_key('doesnotexist') } 'file does not exist';
ok $cs->secret_key('t/secret_key');

my $params = Mojo::Parameters->new('command=listUsers&response=json');
$params->append(apiKey => $cs->api_key);
is $cs->_build_request($params->to_hash), 'http://localhost:8080/client/api?apiKey=plgWJfZK4gyS3mOMTVmjUVg-X-jlWlnfaUJ9GAbBbf9EdM-kAYMmAiLqzzq1ElZLYq_u38zCm0bewzGUdP66mg&command=listUsers&response=json&signature=TTpdDq%252F7j%252FJ58XCRHomKoQXEQds%253D',  'built request';

