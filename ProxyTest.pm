#!/usr/bin/perl

package ProxyTest;

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Cookies;

sub ipchicken_test {

	my $proxy = shift;

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

		my @proxy_split = split(':', $proxy);
			my $current_proxy = $proxy_split[0];

			if ($ip_chicken_ip eq $current_proxy) {

				my $hiv_test_result = 'positive';
				return $hiv_test_result;

			}	
	}

	else {

		my $hiv_test_result = 'negative';
		return $hiv_test_result;

	}


	$cookie_jar->clear;

}

1;
