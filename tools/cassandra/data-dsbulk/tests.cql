SELECT count(*) from thingsboard.ts_kv_cf WHERE entity_type='DEVICE' AND key='mood' ALLOW FILTERING;
SELECT count(*) from tb.ts_kv_cf WHERE entity_type='DEVICE' AND key='mood' ALLOW FILTERING;
SELECT count(*) from thingsboard.ts_kv_partitions_cf WHERE entity_type='DEVICE' AND key='mood' ALLOW FILTERING;
SELECT count(*) from tb.ts_kv_partitions_cf WHERE entity_type='DEVICE' AND key='mood' ALLOW FILTERING;


SELECT count(*) from tb.ts_kv_cf WHERE entity_type='DEVICE' ALLOW FILTERING;
SELECT count(*) from tb.ts_kv_partitions_cf WHERE entity_type='DEVICE' ALLOW FILTERING;


--SELECT * from tb.ts_kv_partitions_cf WHERE entity_type='DEVICE' AND key='mood' ALLOW FILTERING;

