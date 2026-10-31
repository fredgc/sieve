#!/bin/bash
set -e

# Find and increment the version number.
if [[ "$1" == "--release" ]]; then
  perl -i -pe 's/^(version:\s+\d+\.\d+\.)(\d+)\+(\d+)$/$1.($2+1)."+0"/e' pubspec.yaml
else
  perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' pubspec.yaml
fi

# Extract the new version info
version=$(grep '^version: ' pubspec.yaml | sed 's/version: //')
v_num=$(echo "$version" | cut -d'+' -f1)
echo "Rolling version to $version"

# Update doc/about.md
if [ -f doc/about.md ]; then
  perl -i -pe "s/^title: About Sieve.*/title: About Sieve of Eratosthenes (v$version)/" \
       doc/about.md
  perl -i -pe "s/^# About Sieve.*/# About Sieve of Eratosthenes (v$version)/" \
       doc/about.md
fi

# Update README.md, GEMINI.md and plan.md
if [ -f README.md ]; then
  perl -i -pe "s/^# Sieve of Eratosthenes.*/# Sieve of Eratosthenes (v$version)/" \
       README.md
fi
if [ -f GEMINI.md ]; then
  perl -i -pe "s/^Build Version.*/Build Version v$version/" \
       GEMINI.md
fi
if [ -f plan.md ]; then
  perl -i -pe "s/^# Sieve of Eratosthenes.*/# Sieve of Eratosthenes (v$version)/" \
       plan.md
fi

# Update web/version.json
mkdir -p web
cat <<EOF > web/version.json
{
  "version": "$version"
}
EOF

make ASSETS

echo "GREEN: Version is now $version"
