package Perl::MarkupLanguage;

use strict;
use warnings;
use Carp qw/croak/;
use File::Slurp qw/write_file/;

# ABSTRACT: turns baubles into trinkets

our @doc;

sub new {
    my ( $class, %opts ) = @_;
    my $self = {};
    push @doc, '<!DOCTYPE html>';
    push @doc, '<html>';
    return bless $self, $class;
}

sub head {
    my ( $self, %opts ) = @_;
    push @doc, "<head>\n";
    return $self;
}

sub end_head {
    my ( $self, %opts ) = @_;
    push @doc, "</head>";
    return $self;
}

sub body {
    my ( $self, %opts ) = @_;
    my $extras;
    if ( $opts{attributes} ) {
        foreach my $attr ( keys $opts{attributes} ) {
            $extras .= "$attr=\"$opts{$attr} ";
        }
        push @doc, "<body $extras>\n";
    }
    else {
        push @doc, "<body>\n"
    }
    return $self;
}

sub end_body {
    my $self = shift;
    push @doc, '</body>';
    return $self;
}

sub tag {
    my ( $self, %opts ) = @_;

    croak "tag must be defined" if ( !$opts{tag} );

    my $tag = "<$opts{tag}";
    my $extra_tags;

    if ( $opts{options} ) {
        foreach my $open ( values $opts{options} ) {
            $extra_tags .= "<$open>\n";
        }
    }

    if ( $opts{text} ) {
        $extra_tags .= "$opts{text}\n";
    }

    if ( $opts{options} ) {
        foreach my $close ( reverse values $opts{options} ) {
            $extra_tags .= "</$close>\n";
        }
    }

    if ( $opts{attributes} ) {
        foreach my $attr ( keys $opts{attributes} ) {
            $tag .= " $attr=\"$opts{attributes}{$attr}\" ";
        }
    }
    if ( $extra_tags ) {
        $tag .= ">\n$extra_tags</$opts{tag}>\n";
    }
    else {
        $tag .= "></$opts{tag}>\n";
    }
    push @doc, $tag;
    return $self;
}

sub run {
    my $self = shift;

    push @doc, "</html>";

    foreach my $line ( @doc ) {
        print "$line\n";
    }

}

sub write_to {
    my ( $self, %opts ) = @_;
    write_file( $opts{filename}, @doc );
}

1;
