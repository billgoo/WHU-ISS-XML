xquery version "1.0";

let $results := (<dataQ2>
{
    for $a in doc("Flights-Data.xml")/doc/Airport
    let $d :=doc("Flights-Data.xml")/doc,$c :=count($d/Flight/destination[text()=string($a/@airId)])+count($d/Flight/source[text()=string($a/@airId)])
    order by $c 
    return <result>
                {$a/@airId} 
                <count>{$c}</count>
            </result>
}
</dataQ2>)
return $results/result[xs:integer(./count/text()) eq xs:integer(max($results//count/text()))]