#!/bin/bash


# key_id_from_signature [signature_file]
function key_id_from_signature() {
  signature_file="${1}"

  if test '' == "${signature_file}"; then
    fail "Cannot extract key ID from signature.  No signature file specified."
  fi

  # --with-colons may have no effect, here.
  gpg --with-colons --verify "${signature_file}" /dev/null 2>&1 \
    | awk '/using .* key / {print $5}'
}
