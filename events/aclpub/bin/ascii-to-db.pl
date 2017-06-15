#!/usr/bin/perl -p

# Filters a metadata file from START, to translate its
# accented characters into latex format for the DB file.
#
# !!! Isn't there a Perl module that could handle this?

s/Ä/\\\"\{A\}/g;
s/Ë/\\\"{E}/g;
s/Ï/\\\"{I}/g;
s/Ö/\\\"{O}/g;
s/Ü/\\\"{U}/g;
s/ä/\\\"{a}/g;
s/ë/\\\"{e}/g;
s/ï/\\\"{i}/g;
s/ö/\\\"{o}/g;
s/ü/\\\"{u}/g;
s/ÿ/\\\"{y}/g;
s/Æ/{\\AE}/g;
s/æ/{\\ae}/g;
s/ß/{\\ss}/g;
s/Á/\\\'{A}/g;
s/É/\\\'{E}/g;
s/Í/\\\'{I}/g;
s/Ó/\\\'{O}/g;
s/Ú/\\\'{U}/g;
s/Ý/\\\'{Y}/g;
s/á/\\\'{a}/g;
s/é/\\\'{e}/g;
s/í/\\\'{i}/g;
s/ó/\\\'{o}/g;
s/ú/\\\'{u}/g;
s/ý/\\\'{y}/g;
s/À/\\\`{A}/g;
s/È/\\\`{E}/g;
s/Ì/\\\`{I}/g;
s/Ò/\\\`{O}/g;
s/Ù/\\\`{U}/g;
s/à/\\\`{a}/g;
s/è/\\\`{e}/g;
s/ì/\\\`{i}/g;
s/ò/\\\`{o}/g;
s/ù/\\\`{u}/g;
s/Â/\\\^{A}/g;
s/Ê/\\\^{E}/g;
s/Î/\\\^{I}/g;
s/Ô/\\\^{O}/g;
s/Û/\\\^{U}/g;
s/â/\\\^{a}/g;
s/ê/\\\^{e}/g;
s/î/\\\^{i}/g;
s/ô/\\\^{o}/g;
s/û/\\\^{u}/g;
s/Ã/\\\~{A}/g;
s/Ñ/\\\~{N}/g;
s/Õ/\\\~{O}/g;
s/ã/\\\~{a}/g;
s/ñ/\\\~{n}/g;
s/õ/\\\~{o}/g;
s/Å/\\r{A}/g;
s/å/\\r{a}/g;
s/Ç/\\c{C}/g;
s/ç/\\c{c}/g;
s/Ø/{\\O}/g;
s/ø/{\\o}/g;
