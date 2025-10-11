#!/bin/bash

rm -rf core_data_final.sql
sed $'s/\r$//' ./create_db.lst > ./create_db.unix.lst
cat create_db.unix.lst | xargs cat > core_data_final.sql