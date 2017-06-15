#!/usr/bin/perl -p

# Filters a DB (or meta) file so that its entries are friendly for inclusion
#   in PDF metadata
# The result is still a DB (or meta) file.
#
# !!! Isn't there a Perl module that could handle this?
#

next if /^url/;    # don't mess with url or bib_url lines (e.g., don't delete ~)

s/\015//g;         # kill CR from DOS format files

# latex cruft
s/\\@//g;          # kill latex \@, sometimes used after periods
s/\\,//g;          # kill latex \, sometimes used to widen titles in TOC
s/\\\\|\\newline\b//g;    # kill latex newlines
s/\\ / /g;         # latex hard space: convert to ordinary space
s/(?<!\\)~/ /g;    # latex hard space ~ unless preceded by backslash: convert to ordinary space
s/\\&/&/g;         # latex \&

# common latex glyphs
s/---/-/g;         # emdash
s/--/-/g;          # endash
s/(?<!\\)\`\`/"/g;  # smart quotes (also single apostrophe), unless preceded by backslash
s/(?<!\\)\'\'/"/g;
s/(?<!\\)\`/'/g;
s/(?<!\\)\'/'/g;

# collapse whitespace
s/[ \t]+/ /g;
s/^ //;
s/ $//;

# diacritics
#
# See relevant comments in db-to-html.pl
# Here, we flatten to letter without diacritics, for better or worse.
# Should find out how PDF metadata expects its diacritics

s/�/A/g;
s/�/A/g;
s/�/A/g;
s/�/A/g;
s/�/A/g;
s/�/A/g;
s/�/C/g;
s/�/D/g;
s/�/E/g;
s/�/E/g;
s/�/E/g;
s/�/E/g;
s/�/I/g;
s/�/I/g;
s/�/I/g;
s/�/I/g;
s/�/N/g;
s/�/O/g;
s/�/O/g;
s/�/O/g;
s/�/O/g;
s/�/O/g;
s/�/O/g;
s/�/TH/g;
s/�/U/g;
s/�/U/g;
s/�/U/g;
s/�/U/g;
s/�/Y/g;
s/�/a/g;
s/�/a/g;
s/�/ae;/g;
s/�/a/g;
s/�/a/g;
s/�/a/g;
s/�/a/g;
s/�/c/g;
s/�/e/g;
s/�/e/g;
s/�/e/g;
s/�/e/g;
s/�/e/g;
s/�/i/g;
s/�/i/g;
s/�/i/g;
s/�/i/g;
s/�/n/g;
s/�/o/g;
s/�/o/g;
s/�/o/g;
s/�/o/g;
s/�/o/g;
s/�/o/g;
s/�/ss;/g;
s/�/th;/g;
s/�/u/g;
s/�/u/g;
s/�/u/g;
s/�/u/g;
s/�/y/g;
s/�/y/g;

s/\\\'{a}/a/g;
s/\\\'{e}/e/g;
s/\\\'{i}/i/g;
s/\\\'{\\i}/i/g;
s/\\\'{o}/o/g;
s/\\\'{u}/u/g;
s/\\\'{y}/y/g;

s/\\\`{a}/a/g;
s/\\\`{e}/e/g;
s/\\\`{i}/i/g;
s/\\\`{\\i}/i/g;
s/\\\`{o}/o/g;
s/\\\`{u}/u/g;

s/\\\^{a}/a/g;
s/\\\^{e}/e/g;
s/\\\^{i}/i/g;
s/\\\^{\\i}/i/g;
s/\\\^{o}/o/g;
s/\\\^{u}/u/g;

s/\\\"{a}/a/g;
s/\\\"{e}/e/g;
s/\\\"{i}/i/g;
s/\\\"{\\i}/i/g;
s/\\\"{o}/o/g;
s/\\\"{u}/u/g;

s/{\\\"a}/a/g;
s/{\\\"e}/e/g;
s/{\\\"i}/i/g;
s/{\\\"o}/o/g;
s/{\\\"u}/u/g;

s/\\\~{a}/a/g;
s/\\\~{o}/o/g;
s/\\\~{n}/n/g;
s/\\c{c}/c/g;

s/\\v{C}/C/g;
s/\\v{c}/c/g;
s/\\v{E}/E/g;
s/\\v{e}/e/g;
s/\\v{N}/N/g;
s/\\v{n}/n/g;
s/\\v{S}/S/g;
s/\\v{s}/s/g;
s/\\v{Z}/Z/g;
s/\\v{z}/z/g;
s/{\\AA}/A/g;
s/{\\aa}/a/g;
s/{\\AE}/AE/g;
s/{\\ae}/ae/g;
s/{\\ss}/ss/g;

s/{?\\\'a}?/a/g;
s/{?\\\'e}?/e/g;
s/{?\\\'i}?/i/g;
s/{?\\\'\\i}?/i/g;
s/{?\\\'o}?/o/g;
s/{?\\\'u}?/u/g;
s/{?\\\'y}?/y/g;

s/{?\\\`a}?/a/g;
s/{?\\\`e}?/e/g;
s/{?\\\`i}?/i/g;
s/{?\\\`\\i}?/i/g;
s/{?\\\`o}?/o/g;
s/{?\\\`u}?/u/g;

s/{?\\\^a}?/a/g;
s/{?\\\^e}?/e/g;
s/{?\\\^i}?/i/g;
s/{?\\\^\\i}?/i/g;
s/{?\\\^o}?/o/g;
s/{?\\\^u}?/u/g;

s/{?\\\"a}?/a/g;
s/{?\\\"e}?/e/g;
s/{?\\\"i}?/i/g;
s/{?\\\"\\i}?/i/g;
s/{?\\\"o}?/o/g;
s/{?\\\"u}?/u/g;

s/{?\\\~a}?/a/g;
s/{?\\\~o}?/o/g;
s/{?\\\~n}?/n/g;

s/\\\'{A}/A/g;
s/\\\'{E}/E/g;
s/\\\'{I}/I/g;
s/\\\'{O}/O/g;
s/\\\'{U}/U/g;

s/\\\`{A}/A/g;
s/\\\`{E}/E/g;
s/\\\`{I}/I/g;
s/\\\`{O}/O/g;
s/\\\`{U}/U/g;

s/\\\^{A}/A/g;
s/\\\^{E}/E/g;
s/\\\^{I}/I/g;
s/\\\^{O}/O/g;
s/\\\^{U}/U/g;

s/\\\"{A}/A/g;
s/\\\"{E}/E/g;
s/\\\"{I}/I/g;
s/\\\"{O}/O/g;
s/\\\"{U}/U/g;

s/\\\~{A}/A/g;
s/\\\~{O}/O/g;
s/\\\~{N}/N/g;
s/\\c{C}/C/g;
s/\\\'{S}/S/g;
s/\\\'{C}/C/g;
s/\\\'{s}/s/g;
s/\\\'{c}/c/g;

# italicization (not too careful about nested {}).

s/{\\em (.+)}/$1/;
s/\\textit{(.+)}/$1/;
s/\$(.+)\$/$1/;

# Any remaining backslashed sequences get deleted with a WARNING
warn "Don't know how to translate $& to PDF metadata; deleting it" while s/\\[A-Za-z]+//;

# eliminate any remaining curly braces (usually used to protect capitalization in bibtex).
# Unless preceded by backslash.
s/(?<!\\)[{}]//g;

