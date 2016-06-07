#!/bin/bash

cd build
tar -czvf "frontend-$version.tar.gz" *
mv "frontend-$version.tar.gz" ../
cd ..
