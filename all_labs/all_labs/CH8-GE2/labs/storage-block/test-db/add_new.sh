#!/bin/bash

exec oc rsh postgresql-0 psql < add_data.sql
