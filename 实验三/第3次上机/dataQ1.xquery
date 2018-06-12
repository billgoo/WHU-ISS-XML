xquery version "1.0";
<dataQ1>
{
for $f in fn:doc("Flights-Data.xml")/doc/Flight
where $f/source="NPL" and $f/date="2005-12-24"
order by $f/flightid
return <result> {$f} </result>
}
</dataQ1>