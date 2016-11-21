#!/bin/sh

echo "pull begin"

git -C . pull --rebase

echo "push begin"
git -C . push --tags
git -C . push --all

echo "push to cocoapods trunk..."

pod trunk push

#git tag -a 1.0.1 "comment"
#pod lib lint --verbose --allow-warnings
