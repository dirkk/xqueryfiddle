(:~
 : Parse and serialize JSON strings. 
 :
 : (C) 2013, Nobelstiftung
 : by Dirk Kirsten (BaseX GmbH)
 :)
module namespace _ = 'http://lindau-nobel.org/jsonize';

declare function _:serialize($item as item())
{
  element { replace(local-name($item), "_", "__") }
  {
    for $child in $item/node()
    return
      if ($child instance of element())
      then  _:parse($child)
      else $child
  }
};

declare function _:parse($item as item())
{
  element { replace(local-name($item), "__", "_") }
  {
    for $child in $item/node()
    return
      if ($child instance of element())
      then  _:parse($child)
      else $child
  }
};
