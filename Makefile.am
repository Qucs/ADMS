ACLOCAL_AMFLAGS = -I m4

extra = \
  bootstrap.sh    \
  create_files.sh \
  CMakeLists.txt  \
  README.md       \
  README-NGSPICE


EXTRA_DIST= \
  adms.css           \
  adms.xml           \
  admsstyle.xsl      \
  admst.dtd          \
  admst.xml          \
  admstpath.xml      \
  admstpathstyle.xsl \
  admststyle.xsl     \
  metaadms.dtd       \
  metaadms.xsd       \
  metaadmst.dtd      \
  metaadmst.xsd      \
  metaadmstpath.dtd  \
  metaadmstpath.xsd  \
  $(extra)           \
  config.h           \
  config.h.cmake     \
  cmake/modules/FindPerlModules.cmake

SUBDIRS=scripts images admsXml

CLEANFILES=*\~ .*.swp

MAINTAINERCLEANFILES = \
  Makefile.in \
  aclocal.m4 \
  config.h.in \
  configure \
  m4/libtool.m4 \
  m4/lt~obsolete.m4 \
  m4/ltoptions.m4 \
  m4/ltsugar.m4 \
  m4/ltversion.m4

maintainer-clean-local:
	rm -rf $(top_srcdir)/auxconf
