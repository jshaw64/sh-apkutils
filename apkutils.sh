#! /usr/bin/env bash

KEYTOOL=/usr/bin/keytool
JARSIGNER=/usr/bin/jarsigner
ANDROID_BUILD_TOOLS_DIR="/Users/${USER}/Library/Android/sdk/build-tools"

apkutils_generate_alias()
{
  local keystore_path="$1"
  local keystore_password="$2"
  local keystore_alias="$3"
  local key_dname="$4"
  local key_password="$5"
  local key_sigalg="$6"
  local key_keyalg="$7"
  local key_validity="$8"
  local key_keysize="$9"

  $KEYTOOL -genkeypair \
    -keystore "${keystore_path}" \
    -storepass "${keystore_password}" \
    -alias "${keystore_alias}" \
    -dname "${key_dname}" \
    -keypass "${key_password}" \
    -validity "${key_validity}" \
    -sigalg "${key_sigalg}" \
    -keyalg "${key_keyalg}" \
    -keysize "${key_keysize}"
}

apkutils_verify_alias()
{
  local keystore_path="$1"
  local keystore_password="$2"
  local keystore_alias="$3"

  $KEYTOOL -list \
    -keystore "${keystore_path}" \
    -storepass "${keystore_password}" \
    -alias "${keystore_alias}"

  return $?
}

apkutils_jarsign_apk()
{
  local bin_path="$1"
  local keystore_path="$2"
  local keystore_password="$3"
  local keystore_sigalg="$4"
  local keystore_alias="$5"

  $JARSIGNER -verbose \
    -keystore "${keystore_path}" \
    -storepass "${keystore_password}" \
    -sigalg "${keystore_sigalg}" \
    "${bin_path}" \
    "${keystore_alias}"
}
