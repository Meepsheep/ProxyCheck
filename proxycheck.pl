#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Cookies;

my $raw_proxy_file = 'unprocessed_proxies.txt';
my $clean_proxy_file = 'processed_proxies.txt';

open (my $raw_proxies, '<', $raw_proxy_file) or die 'Can\'t open '.$raw_proxy_file."\n";
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

	my $get_site = $ua->get('https://ipchicken.com/');
		my $get_site_as_string = $get_site->as_string;

	if ($get_site_as_string =~ m/img src\=\"images\/1main_10\.gif\" width\=\"/) {
		
		#print $get_site_as_string."\n\n\n";
		my ($ip_chicken_ip) = ($get_site_as_string =~ /size\=\"5\" color\=\"\#0000FF\"\>\<b\>(.*?)\<br\>/s);
			$ip_chicken_ip =~ s/\R//g;
			print 'Reported IP: '.$ip_chicken_ip."\n";

		my @proxy_split = split(':', $proxy);
			my $current_proxy = $proxy_split[0];

			if ($ip_chicken_ip eq $current_proxy) {

				print "\n";
				print '--------------------------------------------------'."\n";
				print $proxy.' works!!'."\n";
					open (my $cl, '>>', $clean_proxy_file) or die 'Could not open '.$clean_proxy_file."\n";
						print $cl $proxy."\n";
					close $cl;
				print 'Saved to '.$clean_proxy_file."\n";
					$working_proxies_so_far = ($working_proxies_so_far + 1);
				print 'Working proxies so far: '.$working_proxies_so_far."\n";
				print '--------------------------------------------------'."\n";
				print "\n";

			}	
	}

	else {

		print $proxy.' sucks'."\n";

	}


	$cookie_jar->clear;
	$number_of_proxies = ($number_of_proxies - 1);

}

