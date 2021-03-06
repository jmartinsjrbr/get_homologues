# -*- perl -*-
# Copyright (C) 2015 Nigel P. Brown
# $Id: blastx.pm $

###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx;

use strict;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7);


###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx::HEADER;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7::HEADER);


###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx::SEARCH;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7::SEARCH);


###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx::SEARCH::RANK;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7::SEARCH::RANK);


###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx::SEARCH::MATCH;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7::SEARCH::MATCH);


###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx::SEARCH::MATCH::SUM;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7::SEARCH::MATCH::SUM);


###########################################################################
package NPB::Parse::Format::BLAST2_OF7::blastx::SEARCH::MATCH::ALN;

use vars qw(@ISA);

@ISA = qw(NPB::Parse::Format::BLAST2_OF7::SEARCH::MATCH::ALN);

my $MAP_ALN = { 'qframe' => 'query_frame' };

sub new {
    my $type = shift;
    my $self = new NPB::Parse::Format::BLAST2_OF7::SEARCH::MATCH::ALN(@_);
    my $text = new NPB::Parse::Record_Stream($self);

    #BLAST2 -outfmt 7
    $self->{'query_frame'} = '';

    my $fields = $self->get_parent(3)->get_record('HEADER')->{'fields'};
    NPB::Parse::Format::BLAST2_OF7::get_fields($text->next_line(1),
                                               $fields, $MAP_ALN, $self);

    if ($self->{'query_frame'} eq '') {
        $self->die("blast column specifier 'qframe' is needed");
    }

    #prepend sign to forward frame
    $self->{'query_frame'} = "+$self->{'query_frame'}"
        if $self->{'query_frame'} =~ /^\d+/;

    #record paired orientations in MATCH list
    push @{$self->get_parent(1)->{'orient'}->{
				 $self->{'query_orient'} .
				 $self->{'sbjct_orient'}
				}}, $self;
    bless $self, $type;
}

sub print_data {
    my ($self, $indent) = (@_, 0);
    my $x = ' ' x $indent;
    $self->SUPER::print_data($indent);
    printf "$x%20s -> %s\n",  'query_frame',  $self->{'query_frame'};
}


###########################################################################
1;
