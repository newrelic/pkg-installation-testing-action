#!/usr/bin/env bash

# This script recreates tag v1 in the repository
# It will:
# 1. Fetch all tags and prune them
# 2. Checkout the main branch
# 3. Delete the tag v1
# 4. Push the deletion of the tag v1
# 5. Create the tag v1


TAG_NAME="v1"

git fetch --tags --prune-tags -f
git checkout origin/main
git tag -d $TAG_NAME
git push --delete origin $TAG_NAME
git tag $TAG_NAME
git push origin $TAG_NAME
