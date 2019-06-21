#!/usr/bin/env bash

echo "Packing release..."

gem build iban_calculator.gemspec

echo "Packing done!"

gem_name=$(find . -name "iban_calculator-*.*.gem" | sed 's^.*/^^')

echo "Publishing package new version: ${gem_name}"

curl -F package=@$gem_name https://$GEM_FURY_PUSH_TOKEN@push.fury.io/getsurance/
