#!/bin/bash

exec oc rsh postgresql-0 psql < select_all.sql
