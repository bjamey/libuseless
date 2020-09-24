' -----------------------------------------------------------------------------
'                                                DTT (c)2005 FSL - FreeSoftLand
'  Title: auddemo
'
'   Date: 12/10/2005
'   By  : Oracle Corporation
' -----------------------------------------------------------------------------

Rem auddemo.sql
Rem
Rem    NAME
Rem      auddemo.sql - SQL Scripts to try our different features
Rem                    in the interMedia audio object
Rem
Rem    DESCRIPTION
Rem      In this demo users are being made familiar with the process
Rem      of creating table with Audio column, inserting data in the 
Rem      table, examining different fields and methods. Users will also
Rem      install a demo plugin for demo format and learn to use it.
Rem
Rem    NOTES
Rem      HTTP related code has been commented out in this file
Rem      users need to uncomments those lines if they want to
Rem      try accessing DATA from their HTTP server. Our HTTP
Rem      call DOES NOT go across firewall so if you are pointing
Rem      to an external site an exception will be raised.
Rem
Rem

Rem IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT 
Rem
Rem IMPORTANT: Parts of this demo require the following to be present
Rem            in order to work properly. 
Rem   1. interMedia fully installed
Rem      and scott/tiger user exists. You can alter the script to 
Rem      use a different user.
Rem   2. AUDIODIR created with read access to scott
Rem   3. testaud.dat present in AUDIODIR
Rem   4. A valid URL with audio data replacing the URL in this
Rem      script (nedc.us.oracle.com...)
Rem   5. <audio2.au> replaced with the accurate audio file name
Rem      available from your URL. This demo uses audio2.au
Rem   6. Reasonable amount of tablespace allocated to audiotest 
Rem   7. DEMO plugins (fplugins.sql and fpluginb.sql) installed
Rem      in ORDPLUGINS schema and EXECUTE privileges granted 
Rem      on ORDX_DEMO_AUDIO to public or at least audiotest.
Rem
Rem IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT 


--   This demo takes users through the scenarios which will allow them
--   to understand and use our intermedia objects. 
--   
--   As a part of this demo, a number of anonymous blocks are
--   added to try out different features of the audio object
--   and use them to write your application.
--

----------------------------------------------------
-- 1: Check Audio/Video/Image intermedia objects
----------------------------------------------------
connect scott/tiger;
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
--select owner, object_name, status from all_objects where object_name like 'ORD%';

-- Check if libraries are defined
-- connect ordsys/<ordsys_passwd>
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
--connect ORDSYS;
--select * from all_libraries;

----------------------------------------------------
-- 2: Create sample table with audio in it
----------------------------------------------------
--
--   T_AUDIO(id number, audio ORDSYS.ORDAudio)
--

CREATE TABLE T_AUDIO(id NUMBER, audio ORDSYS.ORDAudio)
storage (initial 100K next 100K pctincrease 0);

----------------------------------------------------
-- 3: Insert NULL rows into audio table
----------------------------------------------------
INSERT INTO T_AUDIO VALUES( 1, ORDSYS.ORDAudio.init() );

INSERT INTO T_AUDIO VALUES( 2, ORDSYS.ORDAudio.init() );

commit;

----------------------------------------------------
-- 4: Check the rows out
----------------------------------------------------
select id from t_audio;

----------------------------------------------------
-- Exercise methods
----------------------------------------------------
set serveroutput on;

----------------------------------------------------
-- 5: Check all the audio attributes directly
----------------------------------------------------
DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1;

  -- access attributes directly
  -- NOT RECOMMENDED FOR APPLICATION DEVELOPERS

  dbms_output.put_line('DIRECT READ');
  dbms_output.put_line('-----------');
  dbms_output.put_line('Description: '||obj.description);
  dbms_output.put_line('Format: '||obj.format);
  dbms_output.put_line('MimeType: '||obj.mimeType);
  dbms_output.put_line('Source.srcType: '||obj.source.srcType);
  dbms_output.put_line('Source.srcLocation: '||obj.source.srcLocation);
  dbms_output.put_line('Source.srcName: '||obj.source.srcName);
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- dbms_output.put_line('Source.updateTime: '||obj.source.updateTime);
  dbms_output.put_line('Source.local: '||obj.source.local);
  dbms_output.put_line('Encoding: '||obj.Encoding);
  dbms_output.put_line('numberOfChannels: '||obj.numberOfChannels);
  dbms_output.put_line('samplingRate: '||obj.samplingRate);
  dbms_output.put_line('sampleSize: '||obj.sampleSize);
  dbms_output.put_line('compressionType: '||obj.compressionType);
  dbms_output.put_line('audioDuration: '||obj.audioDuration);
  -- call attribute related methods
END;
/

----------------------------------------------------
-- 6: Check all the audio attributes by calling 
--    methods
----------------------------------------------------
DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1;
  -- access methods
  dbms_output.put_line('METHODS');
  dbms_output.put_line('-------');
  dbms_output.put_line('Description: '||obj.getDescription);
  dbms_output.put_line('MimeType: '||obj.getMimeType);
  exception 
  when ORDSYS.ORDAudioExceptions.DESCRIPTION_IS_NOT_SET then
    dbms_output.put_line('Description: NO SET');
END;
/

-- Set description then invoke a method
DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1 FOR UPDATE;
  obj.setDescription('My New Audio File');
  obj.setMimeType('audio/basic');
  dbms_output.put_line('Description: '||obj.getDescription);
  dbms_output.put_line('MimeType: '||obj.getMimeType);
  UPDATE T_AUDIO SET audio=obj WHERE id=1;
  exception
  when ORDSYS.ORDAudioExceptions.DESCRIPTION_IS_NOT_SET then
    dbms_output.put_line('Description: NO SET');
END;
/

-- try the previous anonymous block again to
-- make sure that no exception is raised

-- try getting the format
DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1;
  -- access methods
  dbms_output.put_line('METHODS');
  dbms_output.put_line('-------');
  dbms_output.put_line('Format: '|| obj.getFormat);
  exception 
  when ORDSYS.ORDAudioExceptions.AUDIO_FORMAT_IS_NULL then
    dbms_output.put_line('Format: NOT SET');
END;
/

-- use SQL statements to access length, mimetype and commentlength
SELECT T.audio.getMimeType() MimeType FROM T_AUDIO T where T.id = 1;
SELECT T.audio.getContentLength() FROM T_AUDIO T where T.id = 1;
SELECT T.audio.getCommentLength() FROM T_AUDIO T where T.id = 1;

-- now set the source for 2 rows
--
-----------------------------------------------------------------
-- NOTE THAT DATADIR has been defined and the appropriate audio
-- file exists in the directory
--
-- If you are using URL then make sure that the specified URL
-- exists and that the audio file is accessible from it
-----------------------------------------------------------------
commit;

DECLARE
  obj ORDSYS.ORDAudio;
  obj2 ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1 FOR UPDATE;
  SELECT audio into obj2 from T_AUDIO where id = 2 FOR UPDATE;
  obj.setSource('FILE','AUDIODIR','testaud.dat');
  obj2.setSource('FILE','AUDIODIR','testaud.dat');
  -----------------------------------------------
  -- HTTP ACCESS
  -----------------------------------------------
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- obj2.setSource('HTTP','nedc.us.oracle.com/datacart/intermedia','audio2.au');
  DBMS_OUTPUT.PUT_LINE(obj.getSource);
  DBMS_OUTPUT.PUT_LINE(obj2.getSource);
 
  UPDATE T_AUDIO SET audio=obj WHERE id=1;
  UPDATE T_AUDIO SET audio=obj2 WHERE id=2;
END;
/

commit;
-- check content lengths and also check for 
-- method not implemented exception
DECLARE
  obj ORDSYS.ORDAudio;
  ctx RAW(4000) := NULL;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1 ;
  DBMS_OUTPUT.PUT_LINE(obj.getSource);

  DBMS_OUTPUT.PUT_LINE(obj.getContentLength(ctx));
  EXCEPTION
   WHEN ORDSYS.ORDAudioExceptions.METHOD_NOT_SUPPORTED THEN
    DBMS_OUTPUT.PUT_LINE('Content length cannot be obtained for this source');
END;
/

-- check content lengths and also check for 
-- source plugin exceptio exception
-- with the current scenario, it means that the
-- method is not implemented
DECLARE
  obj2 ORDSYS.ORDAudio;
  ctx RAW(4000) := NULL;

BEGIN
  SELECT audio into obj2 from T_AUDIO where id = 2 ;
  DBMS_OUTPUT.PUT_LINE(obj2.getSource);

  DBMS_OUTPUT.PUT_LINE(obj2.getContentLength(ctx));
  EXCEPTION
   WHEN ORDSYS.ORDSourceExceptions.SOURCE_PLUGIN_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE('Source plugin raised an exception');
   WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('EXCEPTION CAUGHT');
END;
/


-- import data from both the sources
-----------------------------------------------------
-- All the methods from this point on will only be useful
-- and will not raise exception if the data has been 
-- made available
-----------------------------------------------------
DECLARE
  obj ORDSYS.ORDAudio;
  obj2 ORDSYS.ORDAudio;
  ctx RAW(4000) := NULL;

BEGIN
  SELECT audio into obj from T_AUDIO where id = 1 FOR UPDATE;
  SELECT audio into obj2 from T_AUDIO where id = 2 FOR UPDATE;
  DBMS_OUTPUT.PUT_LINE(obj.getSource);
  IF obj.source.isLocal THEN
    DBMS_OUTPUT.PUT_LINE('OBJ1: Data is local');
  ELSE
    DBMS_OUTPUT.PUT_LINE('OBJ1: Data is external');
  END IF;
  obj.import(ctx);
  DBMS_OUTPUT.PUT_LINE(obj.getContentLength(ctx));
  IF obj.source.isLocal THEN
    DBMS_OUTPUT.PUT_LINE('OBJ1: Data is local');
  ELSE
    DBMS_OUTPUT.PUT_LINE('OBJ1: Data is external');
  END IF;


  DBMS_OUTPUT.PUT_LINE(obj2.getSource);
  IF obj2.source.isLocal THEN
    DBMS_OUTPUT.PUT_LINE('OBJ2: Data is local');
  ELSE
    DBMS_OUTPUT.PUT_LINE('OBJ2: Data is external');
  END IF;

  obj2.import(ctx);
  DBMS_OUTPUT.PUT_LINE(obj2.getContentLength(ctx));
  IF obj2.source.isLocal THEN
    DBMS_OUTPUT.PUT_LINE('OBJ2: Data is local');
  ELSE
    DBMS_OUTPUT.PUT_LINE('OBJ2: Data is external');
  END IF;


  UPDATE T_AUDIO SET audio=obj WHERE id=1;
  UPDATE T_AUDIO SET audio=obj2 WHERE id=2;
END;
/

-- try to extract audio attributes
DECLARE
  obj ORDSYS.ORDAudio;
  obj2 ORDSYS.ORDAudio;
  ctx RAW(4000) := NULL;

BEGIN
  SELECT audio into obj from T_AUDIO where id = 1 FOR UPDATE;
  SELECT audio into obj2 from T_AUDIO where id = 2 FOR UPDATE;
  obj.setProperties(ctx);
  obj.setCompressionType('NONE');
  obj.setMimeType('audio/basic');
  obj.setDescription('First AUFF file formatted audio clip');
  obj2.setProperties(ctx);
  obj2.setCompressionType('NONE');
  obj2.setMimeType('audio/basic');
  obj2.setDescription('Second AUFF audio clip');
  UPDATE T_AUDIO SET audio=obj WHERE id=1;
  UPDATE T_AUDIO SET audio=obj2 WHERE id=2;
END;
/
commit;

-- try to all the audio attributes now for obj and obj2
DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 1;
  -- access attributes directly
  -- NOT RECOMMENDED FOR APPLICATION DEVELOPERS
  dbms_output.put_line('DIRECT READ');
  dbms_output.put_line('-----------');
  dbms_output.put_line('Description: '||obj.description);
  dbms_output.put_line('Format: '||obj.format);
  dbms_output.put_line('MimeType: '||obj.mimeType);
  dbms_output.put_line('Source.srcType: '||obj.source.srcType);
  dbms_output.put_line('Source.srcLocation: '||obj.source.srcLocation);
  dbms_output.put_line('Source.srcName: '||obj.source.srcName);
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- dbms_output.put_line('Source.updateTime: '||obj.source.updateTime);
  dbms_output.put_line('Source.local: '||obj.source.local);
  dbms_output.put_line('Encoding: '||obj.Encoding);
  dbms_output.put_line('numberOfChannels: '||obj.numberOfChannels);
  dbms_output.put_line('samplingRate: '||obj.samplingRate);
  dbms_output.put_line('sampleSize: '||obj.sampleSize);
  dbms_output.put_line('compressionType: '||obj.compressionType);
  dbms_output.put_line('audioDuration: '||obj.audioDuration);
  -- call attribute related methods
END;
/

DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 2;
  -- access attributes directly
  -- NOT RECOMMENDED FOR APPLICATION DEVELOPERS
  dbms_output.put_line('DIRECT READ');
  dbms_output.put_line('-----------');
  dbms_output.put_line('Description: '||obj.description);
  dbms_output.put_line('Format: '||obj.format);
  dbms_output.put_line('MimeType: '||obj.mimeType);
  dbms_output.put_line('Source.srcType: '||obj.source.srcType);
  dbms_output.put_line('Source.srcLocation: '||obj.source.srcLocation);
  dbms_output.put_line('Source.srcName: '||obj.source.srcName);
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- dbms_output.put_line('Source.updateTime: '||obj.source.updateTime);
  dbms_output.put_line('Source.local: '||obj.source.local);
  dbms_output.put_line('Encoding: '||obj.Encoding);
  dbms_output.put_line('numberOfChannels: '||obj.numberOfChannels);
  dbms_output.put_line('samplingRate: '||obj.samplingRate);
  dbms_output.put_line('sampleSize: '||obj.sampleSize);
  dbms_output.put_line('compressionType: '||obj.compressionType);
  dbms_output.put_line('audioDuration: '||obj.audioDuration);
  -- call attribute related methods
END;
/

-- try all accessor methods
DECLARE
  obj ORDSYS.ORDAudio;
  ctx RAW(4000) := NULL;

BEGIN
  SELECT audio into obj from T_AUDIO where id = 1;
  dbms_output.put_line('METHODS');
  dbms_output.put_line('-------');
  dbms_output.put_line('Description: '||obj.getDescription);
  dbms_output.put_line('Format: '||obj.getFormat);
  dbms_output.put_line('MimeType: '||obj.getMimeType);
  dbms_output.put_line('Source: '||obj.getSource);
  dbms_output.put_line('ContentLength: '||obj.getContentLength(ctx));
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- dbms_output.put_line('UpdateTime: '||obj.getUpdateTime);
  dbms_output.put_line('Encoding: '||obj.getEncoding);
  dbms_output.put_line('numberOfChannels: '||obj.getNumberOfChannels);
  dbms_output.put_line('samplingRate: '||obj.getSamplingRate);
  dbms_output.put_line('sampleSize: '||obj.getSampleSize);
  dbms_output.put_line('compressionType: '||obj.getCompressionType);
  dbms_output.put_line('audioDuration: '||obj.getAudioDuration);
END;
/

-- try all accessor methods
DECLARE
  obj ORDSYS.ORDAudio;
  ctx RAW(4000) := NULL;

BEGIN
  SELECT audio into obj from T_AUDIO where id = 2;
  dbms_output.put_line('METHODS');
  dbms_output.put_line('-------');
  dbms_output.put_line('Description: '||obj.getDescription);
  dbms_output.put_line('Format: '||obj.getFormat);
  dbms_output.put_line('MimeType: '||obj.getMimeType);
  dbms_output.put_line('Source: '||obj.getSource);
  dbms_output.put_line('ContentLength: '||obj.getContentLength(ctx));
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- dbms_output.put_line('UpdateTime: '||obj.getUpdateTime);
  dbms_output.put_line('Encoding: '||obj.getEncoding);
  dbms_output.put_line('numberOfChannels: '||obj.getNumberOfChannels);
  dbms_output.put_line('samplingRate: '||obj.getSamplingRate);
  dbms_output.put_line('sampleSize: '||obj.getSampleSize);
  dbms_output.put_line('compressionType: '||obj.getCompressionType);
  dbms_output.put_line('audioDuration: '||obj.getAudioDuration);
END;
/

commit;

-- INSTALL YOUR OWN FORMAT PLUGIN
-- 1. log onto ordplugins/<ordplugins_password>
-- 2. create the type ... see fplugins.sql and fpluginb.sql
-- 3. grant privs to public so that the plugin is visible
--    to all the users

set serveroutput on;
 
DECLARE
  obj ORDSYS.ORDAudio;
BEGIN
  SELECT audio into obj from T_AUDIO where id = 2 FOR UPDATE;
  obj.setFormat('DEMO');
  DBMS_OUTPUT.PUT_LINE('FORMAT NOW IS: '||obj.getFormat);
 
  UPDATE T_AUDIO SET audio=obj WHERE id=2;
END;
/
commit; 

-- make sure that data has already been imported

-- try all accessor methods from the format plugin now
DECLARE
  obj ORDSYS.ORDAudio;
  outdata RAW(4000);
  retdata RAW(4000);
  ctx RAW(4000) := NULL;

BEGIN
  SELECT audio into obj from T_AUDIO where id = 2;
  dbms_output.put_line('METHODS');
  dbms_output.put_line('-------');
  dbms_output.put_line('Description: '||obj.getDescription);
  dbms_output.put_line('Format: '||obj.getFormat(ctx));
  dbms_output.put_line('MimeType: '||obj.getMimeType);
  dbms_output.put_line('Source: '||obj.getSource);
  dbms_output.put_line('ContentLength: '||obj.getContentLength(ctx));
----------------------------------------------------------
-- THE NEXT LINE HAS BEEN COMMENTED FOR AUTOMATED TESTING
-- PLEASE UNCOMMENT IT TO TRY OUT THE COMMAND.
----------------------------------------------------------
  -- dbms_output.put_line('UpdateTime: '||obj.getUpdateTime);
  dbms_output.put_line('Encoding: '||obj.getEncoding(ctx));
  dbms_output.put_line('numberOfChannels: '||obj.getNumberOfChannels(ctx));
  dbms_output.put_line('samplingRate: '||obj.getSamplingRate(ctx));
  dbms_output.put_line('sampleSize: '||obj.getSampleSize(ctx));
  dbms_output.put_line('audioDuration: '||obj.getAudioDuration(ctx));

  -- get attributes by name 
  dbms_output.put_line('Copyright: '||obj.getAttribute(ctx, 'Copyright'));
  dbms_output.put_line('Owner: '||obj.getAttribute(ctx, 'Owner'));

  -- send a command to be processed 
  retdata := obj.processAudioCommand(ctx, 'increment','4', outdata);
 
  dbms_output.put_line('Result of incrementing 4: '||utl_raw.cast_to_varchar2(outdata)); 
END;
/

-- CLEANUP
connect scott/tiger;
drop table T_AUDIO;
