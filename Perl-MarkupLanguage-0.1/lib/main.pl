#!/usr/bin/env perl

use strict;
use warnings;
use Perl::MarkupLanguage;

my $user = Perl::MarkupLanguage->new;

$user->head;                         #head and body tags are custom functions

$user->tag(                          #creates a script tag with attribute, src
    tag => 'script',
    attributes => {
        src => 'http://code.jquery.com/jquery-1.8.3.min.js'
    }
);

$user->end_head;                     #head and body tags also have corresponding closings

$user->body;

$user->tag(
    tag        => "h4",
    text       => "This is a test heading",
    attributes => {
        id     => "header_4"
    }
);

$user->tag(
    tag     => "p",
    text    => "this describes the heading",
    options => {
        1   => "code",
        2   => "b"
    },
    attributes => {
        id     => "test_id",
        class  => "test_class"
    }
);

$user->end_body;

$user->run;

$user->write_to(                     #write the output to a file to avoid copy/paste
    filename => '/home/jbert/dev/P-ML/test.html'
);
