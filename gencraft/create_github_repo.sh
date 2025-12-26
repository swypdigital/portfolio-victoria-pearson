#!/bin/bash
# Create private GitHub repository for gencraft-v3.0

TOKEN=$(gh auth token)

curl -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d '{
    "name": "gencraft-v3.0",
    "description": "GenCraft v3.0 - Enterprise-Grade Complete Rebuild with Agentic AI",
    "private": true,
    "auto_init": false
  }'
