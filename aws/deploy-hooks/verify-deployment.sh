#!/bin/bash

result=$(curl -s http://localhost)

if [[ "$result" =~ "Automation for the People" ]]; then
    exit 0
else
    exit 1
fi
