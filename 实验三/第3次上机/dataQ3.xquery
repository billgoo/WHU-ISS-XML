xquery version "1.0";

<result>
{
let $results := (<order>
{
for $a in doc("Flights-Data.xml")/doc/Airport,
    $f in doc("Flights-Data.xml")/doc/Flight,
    $p in doc("Flights-Data.xml")/doc/Passenger,
    $r in doc("Flights-Data.xml")/doc/Reservation
let $c :=count($p[$r/passRef=./passportnumber and $f/@flightId=$r/flightRef and (($f/source/text() eq $a/@airId) or ($f/destination/text() eq $a/@airId))])(:in and out numbers of passenger in same flight and same passno:)
where $c ne 0
order by $c descending
return <airport>
            <name>{string($a/@airId)}</name>
            <count>{$c}</count>
       </airport>
} 
</order>)
for $a2 in doc("Flights-Data.xml")/doc/Airport
let $n2 := $results/airport/name,
    $c2 :=count($n2[./text() eq $a2/@airId])(:which airport:)
where $c2 ne 0
order by $c2 descending
return <airport>
            <name>{string($a2/@airId)}</name>
            <count>{$c2}</count>
       </airport>    
}
</result>    