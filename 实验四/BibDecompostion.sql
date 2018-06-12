DROP TABLE dbo.BookAuthor
DROP TABLE dbo.BookEditor
DROP TABLE dbo.book
DROP TABLE dbo.author
DROP TABLE dbo.editor
CREATE TABLE book
    (
      title VARCHAR(100) PRIMARY KEY ,
      year INT ,
      publisher VARCHAR(30) ,
      price DECIMAL(10, 2)
    );
CREATE TABLE author
    (
      first VARCHAR(20) ,
      last VARCHAR(20) ,
      PRIMARY KEY ( first, last )
    );
CREATE TABLE editor
    (
      first VARCHAR(20) ,
      last VARCHAR(20) ,
      affiliation VARCHAR(10) ,
      PRIMARY KEY ( first, last )
    );
--��BookAuthor�����洢book��author֮��Ĳ��չ�ϵ
CREATE TABLE BookAuthor
    (
      book_title VARCHAR(100) ,
      author_firstName VARCHAR(20) ,
      author_lastName VARCHAR(20) ,
      PRIMARY KEY ( book_title, author_firstName, author_lastName ) ,
      FOREIGN KEY ( book_title ) REFERENCES dbo.book ( title ) ,
      FOREIGN KEY ( author_firstName, author_lastName ) REFERENCES dbo.author ( first, last )
    );
--��BookEditor�����洢book��editor֮��Ĳ��չ�ϵ
CREATE TABLE BookEditor
    (
      book_title VARCHAR(100) ,
      editor_firstName VARCHAR(20) ,
      editor_lastName VARCHAR(20) ,
      PRIMARY KEY ( book_title, editor_firstName, editor_lastName ) ,
      FOREIGN KEY ( book_title ) REFERENCES dbo.book ( title ) ,
      FOREIGN KEY ( editor_firstName, editor_lastName ) REFERENCES dbo.editor ( first, last )
    );

DECLARE @idoc INT
DECLARE @bib XML
SET @bib = '
<bib>
	<book year="1994">
		<title>TCP/IP Illustrated</title>
		<author>
			<last>Stevens</last>
			<first>W.</first>
		</author>
		<publisher>Addison-Wesley</publisher>
		<price> 65.95</price>
	</book>
	<book year="1992">
		<title>Advanced Programming in the Unix environment</title>
		<author>
			<last>Stevens</last>
			<first>W.</first>
		</author>
		<publisher>Addison-Wesley</publisher>
		<price>65.95</price>
	</book>
	<book year="2000">
		<title>Data on the Web</title>
		<author>
			<last>Abiteboul</last>
			<first>Serge</first>
		</author>
		<author>
			<last>Buneman</last>
			<first>Peter</first>
		</author>
		<author>
			<last>Suciu</last>
			<first>Dan</first>
		</author>
		<publisher>Morgan Kaufmann Publishers</publisher>
		<price>39.95</price>
	</book>
	<book year="1999">
		<title>The Economics of Technology and Content for Digital TV</title>
		<editor>
			<last>Gerbarg</last>
			<first>Darcy</first>
			<affiliation>CITI</affiliation>
		</editor>
		<publisher>Kluwer Academic Publishers</publisher>
		<price>129.95</price>
	</book>
</bib>'
--�ֽ���Ϣ����Ӧ����� book
EXEC sp_xml_preparedocument @idoc OUTPUT, @bib
INSERT  INTO book
        SELECT  *
        FROM    OPENXML(@idoc,'bib/book',3)
WITH(title VARCHAR(100) ,
      year INT ,
      publisher VARCHAR(30) ,
      price DECIMAL(10,2))
EXEC sp_xml_removedocument @idoc

--�ֽ���Ϣ����Ӧ����� author
--�˴������ظ�author
DECLARE @authors XML
SET @authors = @bib.query('
<result>
{
	let $a := //author
	for $last in distinct-values(//author/last),
		$first in distinct-values($a[last=$last]/first)
	order by $last,$first
	return	<author>
				<first>{$first}</first>
				<last>{$last}</last>
			</author>
}
</result>
')
EXEC sp_xml_preparedocument @idoc OUTPUT, @authors
INSERT  INTO author
        SELECT  *
        FROM    OPENXML(@idoc,'//author')
WITH (first VARCHAR(20) './first',last VARCHAR(20) './last'	)
EXEC sp_xml_removedocument @idoc

--�ֽ���Ϣ����Ӧ����� editor
EXEC sp_xml_preparedocument @idoc OUTPUT, @bib
INSERT  INTO editor
        SELECT  *
        FROM    OPENXML(@idoc,'//editor')
WITH (first VARCHAR(20) './first',last VARCHAR(20) './last',affiliation VARCHAR(10) './affiliation')
EXEC sp_xml_removedocument @idoc

--�ֽ���Ϣ����Ӧ����� bookAuthor
EXEC sp_xml_preparedocument @idoc OUTPUT, @bib
INSERT INTO BookAuthor
SELECT  *
FROM OPENXML(@idoc,'//author')
WITH (book_title VARCHAR(100) '../title',author_firstName VARCHAR(20) './first',author_lastName VARCHAR(20) './last')
EXEC sp_xml_removedocument @idoc

--�ֽ���Ϣ����Ӧ����� bookEditor
EXEC sp_xml_preparedocument @idoc OUTPUT, @bib
INSERT INTO BookEditor
SELECT  *
FROM OPENXML(@idoc,'//editor')
WITH (book_title VARCHAR(100) '../title',editor_firstName VARCHAR(20) './first',editor_lastName VARCHAR(20) './last')
EXEC sp_xml_removedocument @idoc