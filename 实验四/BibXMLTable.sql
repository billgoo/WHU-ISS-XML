
DROP TABLE bookxml
DROP XML SCHEMA COLLECTION auORed_xsd
--auORed xml schema
CREATE XML SCHEMA COLLECTION auORed_xsd	AS
'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="auORed">
		<xs:complexType>
			<xs:sequence>
				<xs:element name="author" minOccurs="0" maxOccurs="unbounded">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="last">
								<xs:simpleType>
									<xs:restriction base="xs:string">
										<xs:minLength value="1"/>
										<xs:maxLength value="20"/>
									</xs:restriction>
								</xs:simpleType>
							</xs:element>
							<xs:element name="first">
								<xs:simpleType>
									<xs:restriction base="xs:string">
										<xs:minLength value="1"/>
										<xs:maxLength value="20"/>
									</xs:restriction>
								</xs:simpleType>
							</xs:element>
						</xs:sequence>
					</xs:complexType>
				</xs:element>
				<xs:element name="editor" minOccurs="0" maxOccurs="unbounded">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="last">
								<xs:simpleType>
									<xs:restriction base="xs:string">
										<xs:minLength value="1"/>
										<xs:maxLength value="20"/>
									</xs:restriction>
								</xs:simpleType>
							</xs:element>
							<xs:element name="first">
								<xs:simpleType>
									<xs:restriction base="xs:string">
										<xs:minLength value="1"/>
										<xs:maxLength value="20"/>
									</xs:restriction>
								</xs:simpleType>
							</xs:element>
							<xs:element name="affiliation"/>
						</xs:sequence>
					</xs:complexType>
				</xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>';

CREATE TABLE bookxml
    (
      title VARCHAR(100) PRIMARY KEY ,
      year INT ,
      auORed XML(auORed_xsd) ,
      publisher VARCHAR(30) ,
      price DECIMAL(10, 2)
    );
INSERT  INTO bookxml
VALUES  ( 'TCP/IP Illustrated', 1994, '<auORed>
				<author>
					<last>Stevens</last>
					<first>W.</first>
				</author>
			</auORed>', 'Addison-Wesley', 65.95 );
INSERT  INTO bookxml
VALUES  ( 'Advanced Programming in the Unix environment', 1992, '<auORed>
				<author>
					<last>Stevens</last>
					<first>W.</first>
				</author>
			</auORed>', 'Addison-Wesley', 65.95 );
INSERT  INTO bookxml
VALUES  ( 'Data on the Web', 2000, '<auORed>
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
			</auORed>', 'Morgan Kaufmann Publishers', 39.95 );
INSERT  INTO bookxml
VALUES  ( 'The Economics of Technology and Content for Digital TV', 1999,
          '<auORed>
				<editor>
					<last>Gerbarg</last>
					<first>Darcy</first>
					<affiliation>CITI</affiliation>
				</editor>
			</auORed>', 'Kluwer Academic Publishers', 129.95 );
--把数据从bookxml中还原xml
SELECT  year AS '@year' ,
        title ,
        auORed.query('//author') ,
        auORed.query('//editor') ,
        publisher ,
        price
FROM    bookxml
FOR     XML PATH('book') ,
            ROOT('bib')
	