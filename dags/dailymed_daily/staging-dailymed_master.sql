 /* staging.dailymed_master */
 --DROP TABLE IF EXISTS staging.dailymed_master CASCADE;

 CREATE TABLE IF NOT EXISTS staging.dailymed_master (
	spl 				TEXT NOT NULL,
	document_id 		TEXT NOT NULL,
	set_id			 	TEXT,
	version_number 		TEXT,
   	effective_date 		TEXT,
	dailymed_url		TEXT
); 

with xml_table as
(
select slp, xml_content::xml as xml_column
from datasource.dailymed_daily
)

INSERT INTO staging.dailymed_master
SELECT slp, y.*, 'https://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=' || y.set_id
    FROM   xml_table x,
            XMLTABLE('dailymed'
              PASSING xml_column
              COLUMNS 
                document_id 	TEXT  PATH './documentId',
				set_id  		TEXT  PATH './SetId',
				version_number	TEXT  PATH './VersionNumber',
  				effective_date	TEXT  PATH './EffectiveDate'
					) y
ON CONFLICT DO NOTHING;