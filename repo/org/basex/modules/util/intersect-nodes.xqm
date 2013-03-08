(:~
 : This module intersects multiple node sequences to a single one.
 : 
 : @author Christian Grün, BaseX Team 2012
 :)
module namespace _ = "http://basex.org/modules/util/intersect-nodes";

(:~ Dummy node, representing all possible nodes. :)
declare %public variable $_:ALL := <ALL/>;

(:~
 : Intersects all values of the specified map.
 : The keys of the map will be ignored;
 : all values must be node sequences
 : @param map map
 : @return intersected nodes
 :)
declare %public function _:intersect(
    $map as map(*))
    as node()*
{
  fold-left(
    function($s1, $key) {
      let $s2 := $map($key),
          $a1 := _:all($s1),
          $a2 := _:all($s2)
      return if($a1)
        then if($a2) then $_:ALL else $s2
        else if($a2) then $s1 else $s1 intersect $s2
    },
    $_:ALL,
    map:keys($map)
  )
};

(:~
 : Verifies if all nodes are to be returned.
 : @param s node sequence
 : @return result of check
 :)
declare %public function _:all(
    $s as node()*)
    as xs:boolean
{
  count($s) = 1 and $s is $_:ALL
};
