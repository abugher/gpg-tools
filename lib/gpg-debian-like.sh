# This file should be distribution-agnostic enough to be symlinked for
# debian-like systems, including Debian, Devuan, and possibly Ubuntu.  
#
# The real file should not be sourced directly.  The distribution-specific
# symlinks should be sourced instead.
#
# For that reason there is no conf/gpg-debian-like.sh, but there should be
# conf/gpg-debian.sh and similar.  Those will set distribution-specific
# variables used by the distribution-agnostic functions defined here.


# import_distribution_keyrings
# (No arguments.)
#function import_distribution_keyrings() {
#  for keyring in $(
#    for package in "${keyring_packages[@]}"
#    do
#      for keyring_path in $( 
#        dpkg -L debian-keyring | grep '\/usr\/share\/keyrings\/' 
#      ); do 
#        # These packages control a lot of symlinks, mostly *.gpg -> *.pgp .
#        realpath "${keyring_path}"
#      done
#    done \
#      | sort \
#      | uniq
#  )
#}
