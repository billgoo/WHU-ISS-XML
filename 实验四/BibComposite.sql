CREATE VIEW bookEditor_view
    (
      editor_firstName ,
      editor_lastName ,
      book_title ,
      affiliation
    )
AS
    SELECT  editor.first ,
            editor.last ,
            dbo.BookEditor.book_title ,
            editor.affiliation
    FROM    dbo.BookEditor
            JOIN editor ON dbo.BookEditor.editor_firstName = dbo.editor.first
                           AND dbo.BookEditor.editor_lastName = dbo.editor.last
go 
DECLARE @result XML
SET @result = ( SELECT  year AS '@year' ,
                        title AS title ,
                        author_lastName AS "author/last" ,
                        author_firstName AS "author/first" ,
                        editor_lastName AS "editor/last" ,
                        editor_firstName AS "editor/first" ,
                        affiliation AS "editor/affiliation" ,
                        publisher AS publisher ,
                        price AS price
                FROM    book
                        LEFT JOIN bookAuthor ON book.title = bookAuthor.book_title
                        LEFT JOIN bookEditor_view ON book.title = bookEditor_view.book_title
              FOR
                XML PATH('book') ,
                    ROOT('bib')
              )
SELECT  @result.query('<bib>
{
for $t in distinct-values(//book/title),
	$year in distinct-values(//book[title=$t]/@year),
	$publisher in distinct-values(//book[title=$t]/publisher),
	$price in distinct-values(//book[title=$t]/price)
return 
element book
	{	attribute year {$year},
		element title {$t},
		for $book in //book
		let $titile := $book/title
		where $titile = $t and $book/author
		return element author{$book/author/*},
		for $book in //book
		let $titile := $book/title
		where $titile = $t and $book/editor
		return element editor{$book/editor/*},
		element publisher {$publisher},
		element price {$price}
	}
}
</bib>')