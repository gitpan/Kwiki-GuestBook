package Kwiki::GuestBook;
use strict;
use warnings;
use Kwiki::Plugin '-Base';
use Kwiki::Installer '-base';
our $VERSION = '0.10';

const class_id => 'guest_book';
const class_title => 'Guest Book';
const screen_template => 'guest_book_screen.html';
const css_file => 'css/guest_book.css';

sub register {
    my $registry = shift;
    $registry->add(action => 'guest_book');
    $registry->add(user_name_hook => 'update');
    $registry->add(toolbar => 'guest_book_button', 
                   template => 'guest_book_button.html',
                  );
}

sub guest_book {
    my @pages = map {
        $self->pages->new_page($_);
    } sort {lc($a) cmp lc($b)} keys %{$self->user_db};
    $self->render_screen(pages => \@pages);
}

sub update {
    my $preference = $self->preferences->user_name;
    $self->remove_guest($preference->value);
    $self->add_guest($preference->new_value);
}

sub add_guest {
    $self->user_db->{(shift || return)} = 1;
}

sub remove_guest {
    delete $self->user_db->{(shift)};
}

sub user_db {
    io($self->plugin_directory . '/user_name.db')->lock->dbm('DB_File');
}

1;

__DATA__

=head1 NAME 

Kwiki::GuestBook - Kwiki Guest Book Plugin

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2004. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
__template/tt2/guest_book_button.html__
<!-- BEGIN guest_book_button.html -->
<a href="[% script_name %]?action=guest_book" accesskey="g" title="Guest Book">
[% INCLUDE guest_book_button_icon.html %]
</a>
<!-- END guest_book_button.html -->
__template/tt2/guest_book_button_icon.html__
<!-- BEGIN guest_book_button_icon.html -->
Guests
<!-- END guest_book_button_icon.html -->
__template/tt2/guest_book_screen.html__
<!-- BEGIN guest_book_screen.html -->
[% screen_title = "Guest Book" %]
[% INCLUDE kwiki_layout_begin.html %]
<div class="guest_book">
<p>
[% pages.size || 0 %] Guests:
</p>
<ul>
[% FOR page = pages %]
<li>[% page.kwiki_link %]
[% END %]
</ul>
<em>Set your user name in <a href="[% script_name %]?action=user_preferences">Preferences</a></em>
</div>
[% INCLUDE kwiki_layout_end.html %]
<!-- END guest_book_screen.html -->
