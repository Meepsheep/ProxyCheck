#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Cookies;
use HTTP::Request::Common;

my $proxy_file = 'processed_proxies.txt';
my $clean_file = 'goodproxies.txt';

open (my $raw_proxies, '<', $proxy_file) or die 'Can\'t open '.$proxy_file."\n";
	my @unprocessed_proxies = <$raw_proxies>;
		chomp(@unprocessed_proxies);
close $raw_proxies;

my $number_of_proxies = scalar(@unprocessed_proxies);

my $working_proxies_so_far = 0;

while ($number_of_proxies > 0) {

	my $proxy = shift(@unprocessed_proxies);
		chomp($proxy);
			print 'Testing '.$proxy."\n";

	my $cookie_jar = HTTP::Cookies->new;
	my $ua = LWP::UserAgent->new;
		$ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
		$ua->cookie_jar($cookie_jar);
		$ua->proxy(https => 'http://'.$proxy);
		$ua->timeout(5);

	$ua->get('https://en.wikipedia.org/wiki/Main_Page');

	my $loadreg = $ua->get('https://en.wikipedia.org/w/index.php?title=Special:CreateAccount&returnto=Main+Page');
		my $regshit = $loadreg->as_string;

	if ($regshit =~ m/we kindly ask you to enter the words that appear below in the box/) {

		print "\n";
		print '--------------------------------------------------'."\n";
		print $proxy.' works!!'."\n";
			open (my $cl, '>>', $clean_file) or die 'Could not open '.$clean_file."\n";
				print $cl $proxy."\n";
			close $cl;
		print 'Saved to '.$clean_file."\n";
			$working_proxies_so_far = ($working_proxies_so_far + 1);
		print 'Working proxies so far: '.$working_proxies_so_far."\n";
		print '--------------------------------------------------'."\n";
		print "\n";

	}

	else {

		print $proxy.' sucks'."\n";

	}

	$cookie_jar->clear;
	$number_of_proxies = ($number_of_proxies - 1);

}


