(:~
 : Account settings
 :
 : (C) 2012, Nobelstiftung
 :)
module namespace _ = 'http://lindau-nobel.org/account';

import module namespace session = "http://basex.org/modules/web/session";

declare function _:account()
  as element(ul)
{
  <ul class="nav nav-list">
    <li><a href="/restxq/account/edit-details"><i class="icon-pencil"></i> Edit Account</a></li>
    <li><a href="/restxq/logout"><i class="icon-off"></i> Logout</a></li>
  </ul>
};
declare function _:account($return as xs:string)
  as element(ul)
{
  <ul class="nav nav-list">
    <li><a href="/restxq/account/edit-details?r={$return}"><i class="icon-pencil"></i> Edit Account</a></li>
    <li><a href="/restxq/logout"><i class="icon-off"></i> Logout</a></li>
  </ul>
};
