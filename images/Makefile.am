generated_FILES= \
   adms-alias.png        \
   adms-element.png      \
   adms-enumeration.png  \
   adms-list.png         \
   adms-scalar.png       \
   adms-uid.png

EXTRA_DIST=mkimages.pl $(generated_FILES)

# Perl GD module is required to update the figures.
# The script used to be run by make, but it become hard to
# get GD installed and it does not really seem necessary.
# Images are now added to the repository.

CLEANFILES=.*.swp *\~
