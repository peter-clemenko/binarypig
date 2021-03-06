-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements. See the NOTICE file distributed with this
-- work for additional information regarding copyright ownership. The ASF
-- licenses this file to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
-- http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
-- License for the specific language governing permissions and limitations under
-- the License.
--
--  Copyright 2013 Endgame Inc.

%default ES_JAR_DIR '/usr/local/share/elasticsearch/lib'
%default ES_PLUGINS_DIR '/data0/elasticsearch/plugins'
%default ES_CONFIG     'elasticsearch/elasticsearch.yml'
%default INDEX      'binarypig'
%default OBJ        'clamav'
%default BATCHSIZE 1000

%default INPUT 'malware.seq'

register 'binarypig/target/binarypig-1.0-SNAPSHOT-jar-with-dependencies.jar';
register 'lib/wonderdog-1.0-SNAPSHOT.jar'
register /home/hadoop/elasticsearch-0.20.1/lib/elasticsearch-0.20.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/jna-3.3.0.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/jts-1.12.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/log4j-1.2.17.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/lucene-analyzers-3.6.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/lucene-core-3.6.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/lucene-highlighter-3.6.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/lucene-memory-3.6.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/lucene-queries-3.6.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/snappy-java-1.0.4.1.jar;
register /home/hadoop/elasticsearch-0.20.1/lib/spatial4j-0.3.jar;

SET mapred.map.tasks.speculative.execution false;
SET mapred.job.reuse.jvm.num.tasks         1

data = load '$INPUT' as (filename:chararray, timeout:chararray, results:chararray);

STORE data INTO 
   'es://$INDEX/$OBJ?id=filename&json=false&size=$BATCHSIZE' USING 
    com.infochimps.elasticsearch.pig.ElasticSearchStorage('$ES_CONFIG', '$ES_PLUGINS_DIR');
