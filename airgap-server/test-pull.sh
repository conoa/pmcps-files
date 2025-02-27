#!/bin/bash

podman login ec2-13-50-126-32.eu-north-1.compute.amazonaws.com --tls-verify=false

podman pull ec2-13-50-126-32.eu-north-1.compute.amazonaws.com/zot/cilium/cilium-envoy:v1.30.7-1731393961-97edc2815e2c6a174d3d12e71731d54f5d32ea16  --tls-verify=false

helm registry login  ec2-13-50-126-32.eu-north-1.compute.amazonaws.com --insecure

