generated_FILES=adms-scalar.png adms-element.png adms-enumeration.png adms-uid.png adms-alias.png
EXTRA_DIST=mkimages.pl $(generated_FILES)

$(generated_FILES): ${srcdir}/mkimages.pl
	$(PERL) ${srcdir}/mkimages.pl

CLEANFILES=core .*.swp *\~ $(generated_FILES)
