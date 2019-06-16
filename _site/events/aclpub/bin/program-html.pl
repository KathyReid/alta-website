#!/usr/bin/perl

my ($db,$meta) = @ARGV;

my ($title,$booktitle, $urlpattern);
open(META, "$ENV{ACLPUB}/bin/db-to-html.pl $meta |") || die "can't open meta";
while(<META>) {
    chomp;
    my ($key,$value) = split(/\s+/,$_,2);
    $title = $value if $key eq 'title';
    $type = $value if $key eq 'type';
    $abbrev = $value if $key eq 'abbrev';
    $booktitle = $value if $key eq 'booktitle';
    $chairs .= $value."<BR>\n" if $key eq 'chairs';
    $urlpattern = $value if $key eq 'bib_url';
}
close(META);
my $day = "No Day Set";

$urlpattern =~ m/\%0(\d)d/;
my $digits = $1; # checked in bib.pl

# !!! This old code is buggy since it is sensitive to order of fields
# in the db, and overly sensitive to blank lines (e.g., blank at end
# of file affects $papnum, multiple blank lines are significant, etc.)
# See bib.pl for more comments on this and a partial revision.
# But it looks like all the scripts use this code, so keep it for
# now for consistency ...

$curpage = 1;
$papnum = 0;
$authornum = 0;
$prevblank = 1;

open(DB, "$ENV{ACLPUB}/bin/db-to-html.pl $db |") || die;
while(<DB>) {
  chomp;
  $line = $_;

  if ($line =~ /^T:/) {
    $line =~ s/^T:[ ]*//;
    $titles[$papnum] = $line;
    $startauthor[$papnum] = $authornum;
    $prevblank = 0;
  } elsif ($line =~ /^A:/) {
    $line =~ s/^A:[ ]*//;
    $line =~ /^(.*), (.*)$/;
    $ln = $1; $fns = $2;
    $authors[$authornum++] = $fns . " " . $ln;
  } elsif ($line =~ /^L:/) {
    $line =~ s/^L:[ ]*//;
    $length[$papnum] = $line;
    $endauthor[$papnum] = $authornum-1;
  } elsif ($line =~ /^P:/) {
    $line =~ s/^P:[ ]*//;
    $id[$papnum] = $line;
  } elsif ($line =~ /^H:/) {
    $line =~ s/^H:[ ]*//;
    $hours[$papnum] = $line;
  } elsif ($line =~ /^X:/) {
    $line =~ s/^X:[ ]*//;
    $extra[$papnum] = $line;
    $prevblank = 0;
  } elsif ($line =~ /^[ \t]*$/ && !($prevblank)) {
    $prevblank = 1;
    $papnum++;
  }
}
close(DB);


## PROGRAM HTML HEADER TO STDOUT
# !!! should have a generic translation mechanism here,
# not hardcoding specific subsets of the fields everywhere
open(HEADER, "$ENV{ACLPUB}/templates/program.html.head") || die;
while (<HEADER>) {
  s/<XXX TITLE>/$title/g;
  s/<XXX TYPE>/$type/g;
  s/<XXX BOOKTITLE>/$booktitle/g;
  s/<XXX CHAIRS>/$chairs/g;
  print;
}
close(HEADER);

## PROGRAM HTML BODY AND FOOTER TO STDOUT

for ($pn = 0; $pn < $papnum; $pn++) {

  ### Day (*), Session Titles (=), and Misc (+)
  if (defined($extra[$pn])) {
    if ($extra[$pn] !~ /^(.) (.+)$/) {
      print STDERR "format error in extra line: $extra[$pn]\n";
    }
    my $type = $1;
    my $content = $2;

    ## DAY
    if ($type eq '*') {
      print ("<tr><td colspan=2><h4>$content</h4></td></tr>\n");
      $day = $content;
    }

    ## SESSION TITLE
    elsif ($type eq '=') {
      print ("<tr><td valign=top>&nbsp;</td><td valign=top><b>$content</b></td></tr>\n");
    }

    ## EXTRA (Breaks, Invited Talks, Business Meeting, ...)
    elsif ($type eq '+') {
      if ($content !~ /^(\S+) (.+)$/) {
	print STDERR "format error in extra (+) line: $extra[$pn] || $content\n";
      }
      my ($time,$description) = ($1,$2);
      print ("<tr><td valign=top>$time</td><td valign=top>$description</td></tr>\n");
    }
    $numlines += 2;
    #	   printf("\\\\\n");
  } else {

    ### PRINT HOURS IN PROGRAM

    if (defined($hours[$pn]) && $hours[$pn] ne 'none') {
      printf("<tr><td valign=top>%s</td><td valign=top>",$hours[$pn]);
    } else {
      print "<tr><td valign=top>&nbsp;</td><td valign=top>";
    }

    ### PRINT TITLE LINE FOR PROGRAM

    printf("<a href=\"pdf/${abbrev}%0${digits}d.pdf\">",++$pp);
    $line = $titles[$pn];
    $line =~ s/[ \t]*\\\\[ \t]*/ \} \\\\ & \{\\em /g;
    if ($line =~ /Invited Talk:/ || $line =~ /Panel:/) {
      $line =~ s/: /:<i> /;
      printf("%s</i></a><br>\n",$line);
    } else {
      printf("<i>%s</i></a><br>\n",$line);
    }
    $curpage += $length[$pn];

    ### PRINT AUTHORS FOR PROGRAM

    $num_authors = $endauthor[$pn] - $startauthor[$pn] + 1;
	   
    if ($num_authors == 1) {
      printf("%s",$authors[$startauthor[$pn]]);
    } else { 
      $endauth = $endauthor[$pn];
      for ($i = $startauthor[$pn]; $i < $endauth-1; $i++) {
	printf("%s, ",$authors[$i]);
      }
      printf("%s and %s",$authors[$endauth-1],$authors[$endauth]);
    }
    print "</td></tr>\n";
	   
    $numlines += 3;
  }
       
}

printf("</table><p>&nbsp;</body></html>\n");
