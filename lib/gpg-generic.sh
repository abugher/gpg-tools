#!/bin/bash


function key_in_keyring() {
  key_id="${1}"
  if test '' == "${key_id}"; then
    fail "Key ID required to check for key in local keyring."
  fi
  
  gpg -k "${key_id}" > /dev/null 2>&1; ret="${?}"

  return "${ret}"
}


# get_key <key_id>
function get_key() {
  key_id="${1}"
  if test '' == "${key_id}"; then
    fail "Key ID required to get key from server."
  fi
  if ! gpg --keyserver "${key_server}" --recv-keys "${key_id}" > /dev/null 2>&1; then
    error "Failed to get key from server."
    error "  Key ID:  '${key_id}'"
    error "  Server:  '${key_server}'"
    fail "Cannot proceed without getting key from server."
  fi
}


# refresh_key <key_id>
function refresh_key() {
  key_id="${1}"
  if test '' == "${key_id}"; then
    fail "Key ID required to refresh key from server."
  fi
  if ! gpg --keyserver "${key_server}" --refresh-keys "${key_id}" > /dev/null 2>&1; then
    error "Failed to refresh key from server."
    error "  Key ID:  '${key_id}'"
    error "  Server:  '${key_server}'"
    fail "Cannot proceed without refreshing key from server."
  fi
}


# sign_key <key_id>
function sign_key() {
  key_id="${1}"
  if test '' == "${key_id}"; then
    fail "Key ID required to sign key."
  fi
  # gpg seems very opposed to signing without user interaction.
  #
  # Without --batch, output hits the terminal even with stdout and stderr
  # redirected.
  #
  # Interactive vs noninteractive behavior and output is baffling, but this
  # seems to require two 'y' lines.  (The first prompt looks more like a hung
  # program than a question.)
  #
  # I would prefer '<< EOF', except the input lines must be unindented, and
  # that looks ugly to me.
  printf '%s\n%s\n' 'y' 'y' | gpg --batch --command-fd 0 --sign-key "${key_id}" > /dev/null 2>&1; ret="${?}"

  return "${ret}"
}


# update_key <key_id>
function update_key() {
  key_id="${1}"
  if test '' == "${key_id}"; then
    fail "Key ID required to update key."
  fi

  if key_in_keyring "${key_id}"; then
    refresh_key "${key_id}" \
      || fail "Failed to update key:  '${key_id}'"
  else
    get_key "${key_id}" \
      || fail "Failed to get key:  '${key_id}'"
    if ! sign_key "${key_id}"; then
      # Careful here.  This should only delete the same key that was just
      # added, for which signing failed.
      delete_key "${key_id}" \
        || error "Failed to delete key after failing to sign key:  '${key_id}'"
      fail "Failed to sign key:  '${key_id}'"
    fi
  fi
}


# delete_key <key_id>
function delete_key() {
  key_id="${1}"
  if test '' == "${key_id}"; then
    fail "Key ID required to delete key."
  fi
  
  gpg --batch --delete-keys "${key_id}" > /dev/null 2>&1; ret="${?}"

  if test 0 -eq "${ret}"; then
    warn "Deleted key:  '${key_id}'"
  fi

  return "${ret}"
}


# validate_domain <email_address>
#
# This should probably be quieter and have a different name, to be used for
# just checking whether an address is in a domain, without assuming it should
# be.
function validate_domain() {
  email_address="${1}"
  if test '' == "${domain}"; then
    fail "No domain is set.  Cannot validate that address belongs to domain."
  fi
  if ! grep -q "@${domain}\$" <<< "${email_address}"; then
    error "  Expected domain:  '${domain}'"
    error "  Email address:  '${email_address}'"
    fail "Email address is not at the expected domain."
  fi
}


# import_keyring <path>
#function import_keyring() {
#  # This feels like a bad idea.
#  #
#  # This is slow and makes the user keyring large.
#  # 
#  # I think these are just package signing keys.  They may or may not overlap
#  # with mail signing keys, but they are definitely not all in these files.
#  # There is a keyserver for mail signing keys.
#  keyring_path="${1}"
#  if test '' == "${keyring_path}"; then
#    fail "Cannot import keyring; no keyring path specified."
#  fi
#  gpg --keyring "${keyring_path}" --export | gpg --import
#}

