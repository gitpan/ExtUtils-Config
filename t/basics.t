#!/usr/bin/perl -w

use strict;
use warnings FATAL => 'all';
use Test::More 0.88;

use Config;

use ExtUtils::Config;

is(ExtUtils::Config->get('config_args'), $Config{config_args}, "'config_args' is the same for ExtUtils::Config");

my $config = ExtUtils::Config->new;

ok($config->exists('config_args'), "'config_args' is set");
is($config->get('config_args'), $Config{config_args}, "'config_args' is the same for \$Config");

ok(!ExtUtils::Config->exists('nonexistent'), "'nonexistent' is nonexistent");
ok(!$config->exists('nonexistent'), "'nonexistent' is still nonexistent");

ok(!defined $config->get('nonexistent'), "'nonexistent' is not defined");

is_deeply($config->all_config, \%Config, 'all_config is \%Config');

{
	my %myconfig = %Config;
	$config->set('more', 'nomore');
	$myconfig{more} = 'nomore';

	is_deeply($config->values_set, { more => 'nomore' }, 'values_set is { more => \'nomore\'}');

	is_deeply($config->all_config, \%myconfig, 'allconfig is myconfig');
}

$config->pop('more');

is_deeply($config->all_config, \%Config, 'all_config is \%Config again');

$config->push('more', 'more1');
$config->push('more', 'more2');

is($config->get('more'), 'more2', "'more' is now 'more2");
$config->pop('more');
is($config->get('more'), 'more1', "'more' is now 'more1");

my $set = $config->values_set;
$set->{more} = 'more3';
is($config->get('more'), 'more1', "more is still 'more1'");

my $config2 = ExtUtils::Config->new({ more => 'more3' });

is_deeply($config2->values_set, { more => 'more3' }, "\$config2 has 'more' set to 'more3'");

done_testing;
