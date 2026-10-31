#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [valkey] Setting up valkey..."; fi

# Random VALKEY_PASS Generator
if [ -z "${VALKEY_PASS}" ]; then
  {
    VALKEY_PASS=$(openssl rand -base64 33)
    echo "VALKEY_PASS = ${VALKEY_PASS}"
  }
fi

# set VALKEY_PORT
if [ -n "${VALKEY_PORT}" ]; then
  sed -i "s|^port 6379|port ${VALKEY_PORT}|g" "${VALKEY_CONFIG_PATH}"
fi

# set VALKEY_PASS
# Check if the password environment variable is set
if [ -n "${VALKEY_PASS}" ]; then
  # --------------------------------------------------------------------------
  # Step 1: Escape special characters
  # --------------------------------------------------------------------------
  # We use '|' as the sed delimiter, so we must escape it.
  # We also need to escape '\' (escape char) and '&' (sed match reference).
  # Logic:
  #   [\\|&] matches any backslash, pipe, or ampersand.
  #   \\&    replaces it with a literal backslash followed by the matched char.
  ESCAPED_PASS=$(printf '%s\n' "${VALKEY_PASS}" | sed 's/[\\|&]/\\&/g')

  # --------------------------------------------------------------------------
  # Step 2: Update valkey.conf safely
  # --------------------------------------------------------------------------
  # Regex Breakdown:
  #   ^               : Start of the line (Prevents matching inside comments)
  #   [[:space:]]*    : Optional leading whitespace (Indentation)
  #   #*              : Optional comment character (Handles commented out config)
  #   [[:space:]]*    : Optional whitespace after the hash
  #   requirepass     : The exact configuration key
  #   [[:space:]]\+   : At least ONE whitespace (Space or Tab)
  #   foobared        : The default placeholder value (Ensures Idempotency)
  #   [[:space:]]*    : Optional trailing whitespace
  #   $               : End of the line (Ensures strict matching)
  sed -i \
    "s|^[[:space:]]*#*[[:space:]]*requirepass[[:space:]]\+foobared[[:space:]]*$|requirepass ${ESCAPED_PASS}|" \
    "${VALKEY_CONFIG_PATH}"
fi

# set DISALLOW_USER_LOGIN_REMOTELY
if [ "${DISALLOW_USER_LOGIN_REMOTELY}" -eq 1 ]; then
  sed -i "s|^bind.*|bind 127.0.0.1 ::1|g" "${VALKEY_CONFIG_PATH}"
else
  sed -i "s|^bind.*|bind * -::*|g" "${VALKEY_CONFIG_PATH}"
fi

if [ "$DEBUG" = "true" ]; then echo "→ [valkey] Valkey has been set up."; fi
