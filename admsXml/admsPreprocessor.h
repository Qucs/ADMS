/*
This file is part of adms - http://sourceforge.net/projects/mot-adms.

adms is a code generator for the Verilog-AMS language.

Copyright (C) 2002-2012 Laurent Lemaitre <r29173@users.sourceforge.net>
              2015 Guilherme Brondani Torri <guitorri@gmail.com>

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

/*
 * RCS Info
 * $Id: admsPreprocessor.h 985 2008-04-23 18:04:08Z r29173 $
 * 
 * Log
 * $Log$
 * Revision 1.6  2005/11/08 14:07:59  r29173
 * fixed bug (skipp_text becomes a list)
 *
 * Revision 1.5  2005/05/03 07:58:21  r29173
 * moved admsNS into admsFile
 *
 * Revision 1.4  2004/11/19 12:29:56  r29173
 * renamed _C into CAT
 * saved argc, argv into admsmain element
 * added adms:setenv transform
 *
 * Revision 1.3  2004/08/03 12:33:55  r29173
 * import adms-1.21.0 from local CVS
 *
 * Revision 1.2  2004/05/26 13:02:48  r29173
 * added default values to all enumerations
 *
 * Revision 1.1.1.1  2004/05/21 12:20:01  r29173
 * recreated cvs data structure (crashed after revision 1.13.0!)
 *
 * Revision 1.11  2004/03/08 13:58:06  r29173
 * all code lower-cased
 *
 * Revision 1.10  2004/02/06 09:06:03  r29173
 * started implementing code builder in yacc parser
 *
 * Revision 1.9  2004/01/16 10:31:26  r29173
 * added YYDEBUG=1
 *
 * Revision 1.8  2004/01/09 16:23:47  r29173
 * cleaned-up use of #include
 *
 * Revision 1.7  2004/01/06 14:13:13  r29173
 * fixed definition of win32_interface
 *
 * Revision 1.6  2004/01/06 12:35:28  r29173
 * fixed the use of globals: input file and output file
 *
 * Revision 1.5  2004/01/05 11:38:48  r29173
 * removed unused code
 *
 * Revision 1.4  2003/12/11 16:10:11  r29173
 * changed usage of win32_interface
 *
 * Revision 1.3  2003/12/11 16:01:53  r29173
 * changed prefix [epst]_adms_ to [epst]_
 *
 * Revision 1.2  2003/05/21 14:18:01  r29173
 * add rcs info
 *
 */

#ifndef _preprocessor_main_included
#define _preprocessor_main_included

#include "adms.h"

#undef win32_interface
#if defined(WIN32)
#  if defined(insidePreprocessor)
#    define win32_interface __declspec(dllexport)
#  else
#    define win32_interface __declspec(dllimport)
#  endif
#else
#  define win32_interface extern
#endif

// preprocessor flag for static link (MinGW)
#ifdef staticlink
#  undef win32_interface
#  define win32_interface extern
#endif


#define last_char(s)  s+(strlen(s)-1) 

#define INT2ADMS(a) ((p_adms)(long)(a))

win32_interface void adms_preprocessor_get_define_from_argv(const int argc,const char** argv);

win32_interface int adms_preprocessor_getint_yydebug (void);
win32_interface void adms_preprocessor_setint_yydebug (const int val);

win32_interface int adms_preprocessor_registration_printf (const char *filename);

typedef struct s_preprocessor t_preprocessor;
typedef t_preprocessor*       p_preprocessor;
struct s_preprocessor {
  p_adms buffer;
  char * filename;
  FILE * fid;
  int cur_line_position;
  int cur_char_position;
  char * cur_message;
  p_slist cur_continuator_position;
};

typedef struct s_preprocessor_pragma_define_text t_preprocessor_pragma_define_text;
typedef t_preprocessor_pragma_define_text*       p_preprocessor_pragma_define_text;
struct s_preprocessor_pragma_define_text {
  char * name;
  int isArg;
};

typedef struct s_preprocessor_pragma_define t_preprocessor_pragma_define;
typedef t_preprocessor_pragma_define*       p_preprocessor_pragma_define;
struct s_preprocessor_pragma_define {
  char * name;
  int hasArg;
  int isDefined;
  p_slist arg;
  p_slist text;
};

typedef struct s_preprocessor_substitutor t_preprocessor_substitutor;
typedef t_preprocessor_substitutor*       p_preprocessor_substitutor;
typedef struct s_preprocessor_text t_preprocessor_text;
typedef t_preprocessor_text*       p_preprocessor_text;

struct s_preprocessor_substitutor {
  p_preprocessor_pragma_define _pragma;
  p_slist _newarg;
  p_slist _newtext;
  p_preprocessor_text _cr_text;
  p_slist _cr_newarg;
};

struct s_preprocessor_text {
  int _isarg;
  char * _str;
};

typedef struct s_preprocessor_main t_preprocessor_main;
typedef t_preprocessor_main*       p_preprocessor_main;
struct s_preprocessor_main {
  p_preprocessor cr_scanner;
  char * cr_filename;
  p_slist Scanner;
  p_slist Text;
  p_slist Defined;
  p_slist includePath;
  p_slist skipp_text;
  int error;
};

win32_interface p_preprocessor_main pproot (void);
win32_interface void adms_preprocessor_valueto_main (p_preprocessor_main mypreprocessor_main);

win32_interface void preprocessorerror (const char *s);
win32_interface int preprocessorlex ();
win32_interface int preprocessorparse ();

typedef struct s_continuator t_continuator;
typedef t_continuator*       p_continuator;
struct s_continuator {
  int line_position;
  int char_position;
};

win32_interface int adms_preprocessor_get_char_position (p_preprocessor cr_preprocessor);
win32_interface int adms_preprocessor_get_line_position (p_preprocessor cr_preprocessor, int char_pos);

win32_interface int adms_preprocessor_add_message ( char *message);

win32_interface p_preprocessor_pragma_define adms_preprocessor_define_add (char * name);
win32_interface int adms_preprocessor_define_add_default (char * name);
win32_interface int adms_preprocessor_define_add_default_with_text (char * name, char * value);
win32_interface p_preprocessor_pragma_define adms_preprocessor_undefine_add (char * name);
win32_interface p_preprocessor_pragma_define adms_preprocessor_define_add_with_text (char * name, p_slist text);
win32_interface p_preprocessor_pragma_define adms_preprocessor_define_add_with_arg (char * name, p_slist arg);
win32_interface p_preprocessor_pragma_define adms_preprocessor_define_add_with_arg_and_text (char * name, p_slist arg, p_slist text);

win32_interface p_preprocessor_pragma_define adms_preprocessor_pragma_define_exists (char * name);

win32_interface int adms_preprocessor_identifier_is_def (char * name);
win32_interface int adms_preprocessor_identifier_is_ndef (char * name);

win32_interface p_preprocessor_pragma_define adms_preprocessor_identifer_set_undef (char * name);

win32_interface int adms_preprocessor_pragma_define_is_def (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_is_ndef (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_arg (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_noarg (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_nullarg (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_text (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_notext (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_noarg_and_notext (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_noarg_and_text (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_nullarg_and_notext (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_nullarg_and_text (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_arg_and_notext (p_preprocessor_pragma_define pragma);
win32_interface int adms_preprocessor_pragma_define_has_arg_and_text (p_preprocessor_pragma_define pragma);

win32_interface p_preprocessor_text adms_preprocessor_new_text_as_string(char *name);
win32_interface p_slist adms_preprocessor_new_text_as_substitutor (p_preprocessor_pragma_define define, p_slist newarg);

win32_interface void adms_preprocessor_setfile_input (FILE *ifile);
win32_interface FILE *adms_preprocessor_getfile_input (void);
win32_interface void adms_preprocessor_setfile_output (FILE *ifile);
win32_interface FILE *adms_preprocessor_getfile_output (void);

#endif /* _preprocessor_main_included */
