#!/bin/bash

ZIPFILE=pd-webhooks.zip
rm -f $ZIPFILE
zip -r $ZIPFILE node_modules/ index.js package*

echo ""
echo "Upload '$ZIPFILE' to Lamba function"