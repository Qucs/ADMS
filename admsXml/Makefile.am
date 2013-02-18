incfile=constants.vams disciplines.vams adms.implicit.xml dummy.va dummy.xml
incfilec=$(incfile:=.c)

generated_FILES=adms.h adms.c verilogaYacc.y admstpathYacc.y admstpathYacc.h $(incfilec) \
                verilogaLex.c verilogaYacc.c verilogaYacc.h admstpathYacc.c \
                preprocessorLex.c preprocessorYacc.c preprocessorYacc.h
SUFFIXES=.vams .vams.c .va .va.c .xml .xml.c .y.in
$(incfilec):%.c:% ${srcdir}/mkctext.pl
	$(PERL) ${srcdir}/mkctext.pl $< $(top_srcdir)
admstpathYacc.y admstpathYacc.h adms.h adms.c: ${top_srcdir}/adms.xml ${top_srcdir}/admstpath.xml ${srcdir}/mkelements.pl
	$(PERL) ${srcdir}/mkelements.pl $(top_srcdir)
verilogaYacc.y: ${srcdir}/verilogaYacc.y.in ${srcdir}/mkgrammar.pl
	$(PERL) ${srcdir}/mkgrammar.pl ${srcdir}/verilogaYacc.y.in
# -b -> re-defines file-prefix (not y.tab.c)
# -d -> creates #define file
verilogaLex.c: verilogaLex.l
	flex -Pveriloga -overilogaLex.c verilogaLex.l
verilogaYacc.c: verilogaYacc.y verilogaLex.l
	bison -by -d -pveriloga verilogaYacc.y 
	mv -f y.tab.c verilogaYacc.c 
	mv -f y.tab.h verilogaYacc.h 
admstpathYacc.c: admstpathYacc.y admstpathYacc.h
	bison -by -padmstpath admstpathYacc.y 
	mv -f y.tab.c admstpathYacc.c 
preprocessorLex.c: preprocessorLex.l
	flex -Ppreprocessor -opreprocessorLex.c preprocessorLex.l
preprocessorYacc.c: preprocessorYacc.y preprocessorLex.l
	bison -by -d -ppreprocessor preprocessorYacc.y 
	mv -f y.tab.c preprocessorYacc.c 
	mv -f y.tab.h preprocessorYacc.h 

dist_man_MANS = admsXml.1

lib_LTLIBRARIES=libadmsElement.la libadmsPreprocessor.la libadmsVeriloga.la libadmsAdmstpath.la

libadmsElement_la_SOURCES=adms.c
libadmsElement_la_CPPFLAGS=-DinsideElement
libadmsElement_la_LDFLAGS=-no-undefined

preprocessorLex.l: $(incfilec) 
libadmsPreprocessor_la_SOURCES=preprocessorYacc.c preprocessorLex.l preprocessorMain.c
libadmsPreprocessor_la_CPPFLAGS=-DinsidePreprocessor
libadmsPreprocessor_la_LDFLAGS=-no-undefined
libadmsPreprocessor_la_LIBADD=libadmsElement.la

libadmsVeriloga_la_SOURCES=verilogaYacc.c verilogaLex.l
libadmsVeriloga_la_CPPFLAGS=-DinsideVeriloga
libadmsVeriloga_la_LDFLAGS=-no-undefined
libadmsVeriloga_la_LIBADD=libadmsElement.la

libadmsAdmstpath_la_SOURCES=admstpathYacc.c admstpathYacc.h
libadmsAdmstpath_la_CPPFLAGS=-DinsideadmstpathYacc
libadmsAdmstpath_la_LDFLAGS=-no-undefined
libadmsAdmstpath_la_LIBADD=libadmsElement.la

#depends on adms.implicit.xml
bin_PROGRAMS=admsXml
noinst_PROGRAMS=admsCheck

admsXml_SOURCES=admsXml.c
admsXml_LDADD=-lm libadmsElement.la libadmsVeriloga.la libadmsPreprocessor.la libadmsAdmstpath.la

admsXml.c: adms.implicit.xml.c

admsCheck.c=$(incfilec)
admsCheck_SOURCES=admsCheck.c
admsCheck_LDADD=libadmsElement.la

EXTRA_DIST=mkctext.pl mkelements.pl mkgrammar.pl adms.h adms.c \
 preprocessorYacc.h admsPreprocessor.h verilogaYacc.h admsVeriloga.h \
 $(incfile) $(incfilec)

CLEANFILES=.*.swp *\~ core $(generated_FILES)
