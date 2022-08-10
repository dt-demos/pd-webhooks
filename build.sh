#!/bin/bash

ZIPFILE=pd-webhooks.zip
zip -r $ZIPFILE *

echo ""
echo "Upload '$ZIPFILE' to Lamba function"