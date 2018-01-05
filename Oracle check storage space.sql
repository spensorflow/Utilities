Select 
  TABLESPACE_NAME,
  BYTES/1000000000 as USED_GIGABYTES,
  MAX_BYTES/1000000000 as MAX_GIGABYTES,
  BLOCKS,
  MAX_BLOCKS,
  DROPPED 
from user_ts_quotas
where tablespace_name = 'USERS';
  
Select 
  substr(SEGMENT_NAME, 0, 30) Object_Name
  ,substr(TABLESPACE_NAME, 0, 25) as Tablespace
  ,max(segment_type) as Type
  ,((sum(BYTES) / 1024) / 1024) as Mbytes
from user_segments
group by rollup(tablespace_name, segment_name)
order by ((sum(BYTES) / 1024) / 1024) DESC;

