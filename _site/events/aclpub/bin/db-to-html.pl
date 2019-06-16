#!/usr/bin/perl -p

# Filters a DB (or meta) file so that its entries are more HTML-friendly.
# The result is still a DB (or meta) file.
#
# !!! Isn't there a Perl module that could handle this?
# This file gets most common cases but is still slightly incomplete.
# Also, the HTML specification does get extended from time to time.

next if /^url/;    # don't mess with url or bib_url lines (e.g., don't delete ~)

s/\015//g;         # kill CR from DOS format files

# latex cruft
s/\\@//g;          # kill latex \@, sometimes used after periods
s/\\,//g;          # kill latex \, sometimes used to widen titles in TOC
s/\\\\|\\newline\b/<br>/g;    # latex newlines: convert to <br>
s/\\ / /g;         # latex hard space: convert to ordinary space
s/(?<!\\)~/ /g;    # latex hard space ~ unless preceded by backslash: convert to ordinary space
s/(?<!\\)&//g;     # latex &
s/\\&/&/g;         # latex \&
s/(?<!\\)~/&nbsp;/g;    # latex hard space ~ unless preceded by backslash: convert to ordinary space

# common latex glyphs
s/---/&#8212;/g;   # the name "&mdash;" will only be supported in HTML 4
s/--/&#8211;/g;    # the name "&ndash;" will only be supported in HTML 4
s/(?<!\\)\`\`/&ldquo;/g;  # smart quotes (also single apostrophe), unless preceded by backslash
s/(?<!\\)\'\'/&rdquo;/g;
s/(?<!\\)\`/&lsquo;/g;
s/(?<!\\)\'/&rsquo;/g;

# collapse whitespace
s/[ \t]+/ /g;
s/^ //;
s/ $//;

# diacritics.  Pretty good, but:
# - Still not quite complete:
#   Check out http://www.htmlhelp.com/reference/html40/entities/latin1.html
#   and http://molspect.mps.ohio-state.edu/symposium/latexinstruct.html .
# - Redundancy is not exploited.
#   It may be helpful to use more regexp features, like $1 and /e.
# - The optional braces around \'a are not required to match.
# - The braces around \AA, etc., should be optional: an alternative
#   is to follow with a non-letter (typically whitespace, which should then be deleted).
#   In general, the regexps should be rewritten to parse first (the way latex does)
#   and interpret second.
# - There are some characters, like \c{s}, that don't appear 
#   to admit a Latin-1 encoding (see the entry for Dan Tufi\c{s} at W03-0308 
#   in http://acl.ldc.upenn.edu/W/W03/ ).

s/�/&Aacute;/g; 
s/�/&Acirc;/g; 
s/�/&Agrave;/g; 
s/�/&Aring;/g; 
s/�/&Atilde;/g; 
s/�/&Auml;/g; 
s/�/&Ccedil;/g; 
s/�/&ETH;/g; 
s/�/&Eacute;/g; 
s/�/&Ecirc;/g; 
s/�/&Egrave;/g; 
s/�/&Euml;/g; 
s/�/&Iacute;/g; 
s/�/&Icirc;/g; 
s/�/&Igrave;/g;
s/�/&Iuml;/g; 
s/�/&Ntilde;/g; 
s/�/&Oacute;/g; 
s/�/&Ocirc;/g; 
s/�/&Ograve;/g; 
s/�/&Oslash;/g; 
s/�/&Otilde;/g;
s/�/&Ouml;/g; 
s/�/&THORN;/g; 
s/�/&Uacute;/g; 
s/�/&Ucirc;/g; 
s/�/&Ugrave;/g; 
s/�/&Uuml;/g; 
s/�/&Yacute;/g; 
s/�/&aacute;/g; 
s/�/&acirc;/g; 
s/�/&aelig;/g; 
s/�/&agrave;/g; 
s/�/&aring;/g; 
s/�/&atilde;/g; 
s/�/&auml;/g; 
s/�/&ccedil;/g; 
s/�/&eacute;/g; 
s/�/&ecirc;/g; 
s/�/&egrave;/g; 
s/�/&eth;/g; 
s/�/&euml;/g; 
s/�/&iacute;/g; 
s/�/&icirc;/g; 
s/�/&igrave;/g; 
s/�/&iuml;/g; 
s/�/&ntilde;/g; 
s/�/&oacute;/g; 
s/�/&ocirc;/g; 
s/�/&ograve;/g; 
s/�/&oslash;/g; 
s/�/&otilde;/g; 
s/�/&ouml;/g; 
s/�/&szlig;/g; 
s/�/&thorn;/g; 
s/�/&uacute;/g; 
s/�/&ucirc;/g; 
s/�/&ugrave;/g; 
s/�/&uuml;/g; 
s/�/&yacute;/g; 
s/�/&yuml;/g; 

s/\\\'{a}/&aacute;/g;
s/\\\'{e}/&eacute;/g;
s/\\\'{i}/&iacute;/g;
s/\\\'{\\i}/&iacute;/g;
s/\\\'{o}/&oacute;/g;
s/\\\'{u}/&uacute;/g;
s/\\\'{y}/&yacute;/g;

s/\\\`{a}/&agrave;/g;
s/\\\`{e}/&egrave;/g;
s/\\\`{i}/&igrave;/g;
s/\\\`{\\i}/&igrave;/g;
s/\\\`{o}/&ograve;/g;
s/\\\`{u}/&ugrave;/g;

s/\\\^{a}/&acirc;/g;
s/\\\^{e}/&ecirc;/g;
s/\\\^{i}/&icirc;/g;
s/\\\^{\\i}/&icirc;/g;
s/\\\^{o}/&ocirc;/g;
s/\\\^{u}/&ucirc;/g;

s/\\\"{a}/&auml;/g;
s/\\\"{e}/&euml;/g;
s/\\\"{i}/&iuml;/g;
s/\\\"{\\i}/&iuml;/g;
s/\\\"{o}/&ouml;/g;
s/\\\"{u}/&uuml;/g;

s/{\\\"a}/&auml;/g;
s/{\\\"e}/&euml;/g;
s/{\\\"i}/&iuml;/g;
s/{\\\"o}/&ouml;/g;
s/{\\\"u}/&uuml;/g;

s/\\\~{a}/&atilde;/g;
s/\\\~{o}/&otilde;/g;
s/\\\~{n}/&ntilde;/g;
s/\\c{c}/&ccedil;/g;
s/\\c{s}/&#351;/g;

s/\\v{C}/&#268;/g;
s/\\v{c}/&#269;/g;
s/\\v{E}/&#282;/g;
s/\\v{e}/&#283;/g;
s/\\v{N}/&#327;/g;
s/\\v{n}/&#328;/g;
s/\\v{R}/&#344;/g;
s/\\v{r}/&#345;/g;
s/\\v{S}/&#352;/g;
s/\\v{s}/&#353;/g;
s/\\v{Z}/&#142;/g;
s/\\v{z}/&#158;/g;
s/{\\AA}/&Aring;/g;
s/{\\aa}/&aring;/g;
s/{\\AE}/&AElig;/g;
s/{\\ae}/&aelig;/g;
s/{\\ss}/&szlig;/g;

s/{?\\\'a}?/&aacute;/g;    
s/{?\\\'e}?/&eacute;/g;
s/{?\\\'i}?/&iacute;/g;
s/{?\\\'\\i}?/&iacute;/g;
s/{?\\\'o}?/&oacute;/g;
s/{?\\\'u}?/&uacute;/g;
s/{?\\\'y}?/&yacute;/g;

s/{?\\\`a}?/&agrave;/g;
s/{?\\\`e}?/&egrave;/g;
s/{?\\\`i}?/&igrave;/g;
s/{?\\\`\\i}?/&igrave;/g;
s/{?\\\`o}?/&ograve;/g;
s/{?\\\`u}?/&ugrave;/g;

s/{?\\\^a}?/&acirc;/g;
s/{?\\\^e}?/&ecirc;/g;
s/{?\\\^i}?/&icirc;/g;
s/{?\\\^\\i}?/&icirc;/g;
s/{?\\\^o}?/&ocirc;/g;
s/{?\\\^u}?/&ucirc;/g;

s/{?\\\"a}?/&auml;/g;
s/{?\\\"e}?/&euml;/g;
s/{?\\\"i}?/&iuml;/g;
s/{?\\\"\\i}?/&iuml;/g;
s/{?\\\"o}?/&ouml;/g;
s/{?\\\"u}?/&uuml;/g;

s/{?\\\~a}?/&atilde;/g;
s/{?\\\~o}?/&otilde;/g;
s/{?\\\~n}?/&ntilde;/g;

s/\\\'{A}/&Aacute;/g;
s/\\\'{E}/&Eacute;/g;
s/\\\'{I}/&Iacute;/g;
s/\\\'{O}/&Oacute;/g;
s/\\\'{U}/&Uacute;/g;
s/\\\'{Y}/&Yacute;/g;

s/\\\`{A}/&Agrave;/g;
s/\\\`{E}/&Egrave;/g;
s/\\\`{I}/&Igrave;/g;
s/\\\`{O}/&Ograve;/g;
s/\\\`{U}/&Ugrave;/g;

s/\\\^{A}/&Acirc;/g;
s/\\\^{E}/&Ecirc;/g;
s/\\\^{I}/&Icirc;/g;
s/\\\^{O}/&Ocirc;/g;
s/\\\^{U}/&Ucirc;/g;

s/\\\"{A}/&Auml;/g;
s/\\\"{E}/&Euml;/g;
s/\\\"{I}/&Iuml;/g;
s/\\\"{O}/&Ouml;/g;
s/\\\"{U}/&Uuml;/g;

s/\\\~{A}/&Atilde;/g;
s/\\\~{O}/&Otilde;/g;
s/\\\~{N}/&Ntilde;/g;
s/\\c{C}/&Ccedil;/g;
s/\\\'{S}/&#346;/g;
s/\\\'{C}/&#262;/g;
s/\\\'{s}/&#347;/g;
s/\\\'{c}/&#263;/g;

s/{?\\\'C}?/&#262;/g;
s/{?\\\'c}?/&#263;/g;
s/{?\\\'S}?/&#346;/g;
s/{?\\\'s}?/&#347;/g;

# thanks to Jeff Heinz, SIGMORPHON 2008:

s/\\\={a}/&#257;/g;
s/\\\={e}/&#275;/g;
s/\\\={i}/&#299;/g;
s/\\\={o}/&#333;/g;
s/\\\={u}/&#363;/g;

s/\\\={A}/&#256;/g;
s/\\\={E}/&#274;/g;
s/\\\={I}/&#298;/g;
s/\\\={O}/&#332;/g;
s/\\\={U}/&#362;/g;

# end thanks to Jeff Heinz, SIGMORPHON 2008


# italicization (not too careful about nested {}).
# !!! could also try to fix math, e.g., "$n$-gram"

s/{\\em (.+)}/<i>$1<\/i>/;
s/\\textit{(.+)}/<i>$1<\/i>/;
s/\\emph{(.+)}/<i>$1<\/i>/;

# boldface
s/{\\bf (.+)}/<b>$1<\/b>/;
s/\\textbf{(.+)}/<b>$1<\/b>/;

# small caps - just print normally
s/\\textsc{(.+)}/$1/;


# Any remaining backslashed sequences get deleted with a WARNING
warn "Don't know how to translate $& to HTML; deleting it" while s/\\[A-Za-z]+//;

# eliminate any remaining curly braces (usually used to protect capitalization in bibtex).
# Unless preceded by backslash.
s/(?<!\\)[{}]//g;

