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

=pod

=head1 NAME

    Perl-MarkupLanguage -- a Dynamic, Quick and Easy Way to Produce HTML

=head1 SYNOPSIS

    use Perl::MarkupLanguage;

    my $user = Perl::MarkupLanguage->new;

    $user->head;

    $user->tag(
        tag => 'script',
        attributes => {
            src => 'http://code.jquery.com/jquery-1.8.3.min.js'
        }
    );

    $user->end_head;

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

    $user->write_to(
        filename => '/home/jbert/dev/P-ML/test.html'
    );

=head1 DESCRIPTION

    new() - creates object as well as <!DOCTYPE html> and <html>

    head() - creates a head tag

    end_head() - closes head()

    body() - creates a body tag. can take attributes same way as tag().

    end_body() - closes body()

    tag() - creates an other specified tag.
        $object->tag(
            tag  => "tag_name",
            text => "text inside tag", #(optional)
            attributes => {
                attr_1 => "attr_1_name"
            }, #(optional)
            options => {
                opt_1 => "opt_1_name" #usually <code>, <b>, etc
            }
        );

    run() - prints out result

    write_to - writes output to specified filename

=head1 AUTHOR

    James Albert <jamesrobertalbert@gmail.com>
























