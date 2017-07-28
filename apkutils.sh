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

apkutils_zipalign_apk()
{
  local bin_src_path="$1"
  local bin_dst_path="$2"
  local android_sdk_version="$3"

  local zipalign_path="${ANDROID_BUILD_TOOLS_DIR}/${android_sdk_version}/zipalign"

  $zipalign_path -v 4 "${bin_src_path}" "${bin_dst_path}"
}

apkutils_apksign_apk()
{
  local bin_src_path="$1"
  local keystore_path="$2"
  local keystore_password="$3"
  local keystore_alias="$4"
  local android_sdk_version="$5"

  local apksigner_path="${ANDROID_BUILD_TOOLS_DIR}/${android_sdk_version}/apksigner"

  $apksigner_path sign \
    --ks "${keystore_path}" \
    --ks-key-alias "${keystore_alias}" \
    --ks-pass pass:"${keystore_password}" \
    "${bin_src_path}"
}
