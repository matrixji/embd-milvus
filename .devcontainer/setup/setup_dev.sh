#!/bin/bash

set -e

project_dir=$(dirname $(dirname $(cd $(dirname $0); pwd)))

py3=$(which python3.8 || which python3)

$py3 -m pip install --user -U pip
$py3 -m pip install --user -r ${project_dir}/requirements.txt
