#!/bin/sh

libname='hvm'
rm -f "${libname}.zip"
zip -r "${libname}.zip" haxelib.json src README.md run.n hvm.n
echo "Saved as ${libname}.zip. Remember to do git-tag"
