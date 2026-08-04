#!/bin/bash
perl -MText::CSV_XS=csv -MHTML::Entities=decode_entities -E '
  $csv = csv(in => shift, encoding => "utf-8");
  for $row (reverse @$csv) {
    $row->[1] =~ m{^https://x.com/yuuki26/} or next;
    ($year) = $row->[2] =~ /^(\d{4})/;
    $body = decode_entities($row->[3]);
    $body =~ s/\n/\x{2424}/g;
    push @{ $rows{$year} }, [$row->[2], $body, $row->[1]];
  }
  for $year (2021 .. 2026) {
    next unless @{ $rows{$year} };
    csv(
      in => $rows{$year},
      encoding => "utf-8",
      sep_char => "\t",
      eol => "\n",
      quote_char => undef,
      escape_char => undef,
      out => "$year.tsv",
    );
  }
' yuuki26-*.csv
