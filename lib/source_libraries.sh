# This may not technically be a library, as it defines no functions.  It is
# also not a stand-alone script, and it does deal with libraries.

for lib in "${libs[@]}"; do
  if ! source "lib/${lib}.sh"; then
    printf '%s\n' "Failed to source library:  '${lib}'" >&2
    exit 1
  fi
  if ! source "conf/${lib}.sh"; then
    printf '%s\n' "Failed to source configuration:  '${lib}'" >&2
    exit 2
  fi
done

