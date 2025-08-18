# DataStax Bulk Loader for Cassandra

This tool is able to do data migration without downtime

In this folder you can find examples for Kubernetes from the real migration. 
This migration process takes 3 parts:
- upload timeseries data with no partitions (INFINITY)
- process data to make partitions by MONTHS
- load timeseries data to the new empty keyspace from prepared json 
- load partitions data to the new empty keyspace from prepared json

## Reference

https://github.com/datastax/dsbulk

## Overview

The DataStax Bulk Loader tool (DSBulk) is a unified tool for loading into and unloading from Cassandra-compatible storage engines, such as OSS Apache Cassandra®, DataStax Astra and DataStax Enterprise (DSE).

Out of the box, DSBulk provides the ability to:

    Load (import) large amounts of data into the database efficiently and reliably;
    Unload (export) large amounts of data from the database efficiently and reliably;
    Count elements in a database table: how many rows in total, how many rows per replica and per token range, and how many rows in the top N largest partitions.

See details on https://github.com/datastax/dsbulk