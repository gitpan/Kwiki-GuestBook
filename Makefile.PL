use inc::Module::Install;

name('Kwiki-GuestBook');
author('Brian Ingerson <ingy@cpan.org>');
abstract('Kwiki Plugin to Make a Guest Book of Users');
license('perl');
version_from('lib/Kwiki/GuestBook.pm');

requires(qw(
    perl 5.6.1
    Kwiki 0.34
    Kwiki::UserName 0.13
    DB_File 0
    DB_File::Lock 0
));

check_nmake();

&WriteAll();
