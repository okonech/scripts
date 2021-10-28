#!/bin/bash

cd '/home/alex/Steam/steamapps/common/Divinity Original Sin 2/'
mv ./bin ./bin.bak
ln -s DefEd/bin bin
cd bin
mv ./SupportTool.exe ./SupportTool.bak
ln -s EoCApp.exe SupportTool.exe
