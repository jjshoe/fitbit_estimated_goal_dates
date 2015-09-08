#!/usr/bin/perl

use strict;
use warnings;

use DateTime;
use POSIX;

use Data::Dumper;

my @goal_weights = (215, 200, 185, 175);
my @measurements;
my @loss;
my $total_weight_loss;

open(my $fh, '<', 'data.csv');

foreach my $line (<$fh>)
{
        $line =~ /(\d+\.{0,1}\d*)\s+lbs/;
        push(@measurements, $1);
}

my $average_daily_lost = sprintf("%.2f", ($measurements[scalar(@measurements) - 1] - $measurements[0]) / scalar(@measurements));

my $weight_to_lose = $measurements[0] - $goal_weights[scalar(@goal_weights - 1)];

if ($weight_to_lose <= 0)
{
        print "YAY GOAL MET!!!\n";
        exit;
}

my $days_left = $weight_to_lose / $average_daily_lost;

if ($days_left <= 0)
{
        print "You've gained more than you lost, time for a change!\n";
        exit;
}

foreach my $goal (@goal_weights)
{
        if ($measurements[0] > $goal)
        {
                my $goal_date = DateTime->today->add(days => ($measurements[0] - $goal) / .28);
                my $average_daily_lost_goal_date = DateTime->today->add(days => ($measurements[0] - $goal) / $average_daily_lost);

                print "Goal ${goal}lbs " . $goal_date->month_name . " " . $goal_date->day . " " . $goal_date->year . "\n"; 
                print "Likely date " . $average_daily_lost_goal_date->month_name . " " . $average_daily_lost_goal_date->day . " " . $average_daily_lost_goal_date->year . "\n\n"; 
        }
}

print "\nYour average daily weight loss is ${average_daily_lost}lbs\n";
