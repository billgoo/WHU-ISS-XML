xquery version "1.0";
<dataQ4>
{
let $results := 
(
    for $f in doc("Flights-Data.xml")/doc/Flight,
		$r in doc("Flights-Data.xml")/doc/Reservation
    where $r/flightRef=$f/@flightId
    order by $f/@flightId
    return <result>
                <flightId>{$f/@flightId}</flightId> 
                {$f/destination}
            </result>
)
return $results
}
</dataQ4>