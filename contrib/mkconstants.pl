#!/usr/bin/env perl
# Generate a Verilog-AMS 'constants.vams' standard header file

use strict;
use warnings;
use bignum (accuracy => 17, qw/PI e/); # adjusts number of significant figures
use English qw/-no_match_vars/;

# Calculate mathematical constants using Perl's arbitrary-precision arithmetic
my %maths_consts = (
    M_1_PI     => 1.0 / PI,
    M_2_PI     => 2.0 / PI,
    M_2_SQRTPI => 2.0 / sqrt(PI),
    M_E        => e,
    M_LN10     => log(10.0),
    M_LN2      => log(2.0),
    M_LOG10E   => 1.0 / log(10.0),
    M_LOG2E    => 1.0 / log(2.0),
    M_PI       => PI,
    M_PI_2     => PI / 2.0,
    M_PI_4     => PI / 4.0,
    M_SQRT1_2  => 1.0 / sqrt(2.0),
    M_SQRT2    => sqrt(2.0),
    M_TWO_PI   => 2.0 * PI,
);

# Get physical constants from NIST 2018 CODATA adjusted listing
my %phys_consts = (
    P_C        => { desc  => "speed of light in vacuum",     },
    P_CELSIUS0 => { desc  => "zero degrees Celsius",
                    val   => "273.15",
                    err   => "(exact)",
                    units => "K",                            },
    P_EPS0     => { desc  => "vacuum electric permittivity", },
    P_H        => { desc  => "Planck constant",              },
    P_K        => { desc  => "Boltzmann constant",           },
    P_Q        => { desc  => "elementary charge",            },
    P_U0       => { desc  => "vacuum mag. permeability",     },
);
my $allascii_txt = "allascii.txt";
unless (-r $allascii_txt) {
    print "Attempting to download '$allascii_txt' from NIST website.\n";
    my $url = "https://physics.nist.gov/cuu/Constants/Table/allascii.txt";
    system(qq/curl -s -o "$allascii_txt" "$url"/) == 0
        or die "Could not download '$allascii_txt': $OS_ERROR";
}
open my $fh, "<", $allascii_txt
    or die "Could not open '$allascii_txt' for reading: $OS_ERROR";
while (my $line = <$fh>) {
    next if $NR < 12;
    chomp $line;
    my ($desc, $val, $err, $units) = split /\s{2,}/, $line;
    foreach my $sym (keys %phys_consts) {
        if ($phys_consts{$sym}{desc} eq $desc) {
            $phys_consts{$sym}{val}   = $val =~ s/\s//gr;
            $phys_consts{$sym}{err}   = $err =~ s/\s//gr;
            $phys_consts{$sym}{units} = $units;
            last;
        }
    }
}
close $fh or die "Could not close '$allascii_txt': $OS_ERROR";

# Generate output file
my $constants_vams = "constants.vams";
open $fh, ">", $constants_vams
    or die "Could not open '$constants_vams' for writing: $OS_ERROR";
select $fh;
print <<'EOF';
/*
This file is part of adms - http://sourceforge.net/projects/mot-adms.

adms is a code generator for the Verilog-AMS language.

Copyright (C) 2016 Guilherme Brondani Torri <guitorri@gmail.com>
              2016 Felix Salfelder <felix@salfelder.org>
              2022 Neal Graham Wood <neal.wood@protonmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

`ifdef CONSTANTS_VAMS
`else
`define CONSTANTS_VAMS 1

/* Mathematical constants */

EOF
foreach my $sym (sort keys %maths_consts) {
    my $val = $maths_consts{$sym};
    printf "%-8s%-16s%s\n", "`define", $sym, $val;
}
print <<'EOF';

/* Physical constants */

EOF
foreach my $sym (sort keys %phys_consts) {
    my ($desc, $val, $units) = @{$phys_consts{$sym}}{qw/desc val units/};
    printf "// %s -- %s\n", $desc, $units;
    printf "%-8s%-16s%s\n\n", "`define", $sym, $val;
}
print <<'EOF';
`endif // CONSTANTS_VAMS
EOF
close $fh or die "Could not close '$constants_vams': $OS_ERROR";
