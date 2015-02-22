#!/bin/bash
result=$(curl -s http://localhost:8080/target)
myval=${result:-Stopped}

echo "turret=$myval"
