/*
This file is part of adms - http://sourceforge.net/projects/mot-adms.

adms is a code generator for the Verilog-AMS language.

Copyright (C) 2016 Guilherme Brondani Torri <guitorri@gmail.com>
              2016 Felix Salfelder <felix@salfelder.org>

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

`ifdef DISCIPLINES_VAMS
`else
`define DISCIPLINES_VAMS 1

// Electrical current
nature current
  access = I;
  units = "A";
  abstol = 0.001234;
endnature

// Electrical potential
nature voltage
  access = V;
  units = "V";
  abstol = 0.0004321;
endnature

// Power
nature power
  access = Pwr;
  units = "W";
  abstol = 0.00101010;
endnature

// Magnetic flux
nature flux
  access = Phi;
  units = "We";
endnature

// how hot it is.
nature temperature
  access = Temp;
  units = "K";
  abstol = 3.14;
endnature

// required for heat energy exchange.
discipline thermal
  potential temperature;
  flow power;
enddiscipline

// Electrical discipline
discipline electrical
  potential voltage;
  flow current;
enddiscipline

discipline magnetic
  potential voltage; // FIXME
  flow current; // FIXME
enddiscipline

discipline rotational_omega
  potential voltage; // FIXME
  flow current; // FIXME
enddiscipline

`endif // DISCIPLINES_VAMS
