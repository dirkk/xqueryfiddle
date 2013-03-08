(:~
 : Light-weight session module.
 :
 : @author BaseX GmbH 2012, Christian Grün
 :)
module namespace _ = "http://basex.org/modules/web/session";

import module namespace session = 'http://basex.org/modules/session';

(: User id string. :)
declare variable $_:ID := 'ID';
(: User role. :)
declare variable $_:ROLE := 'Role';

(:~
 : Registers a user with the specified id.
 : @param id user id
 :)
declare function _:login(
  $id as xs:string)
  as empty-sequence()
{
  session:set($_:ID, $id)
};

(:~
 : Registers a user with the specified id and role.
 : @param id user id
 : @param role user role
 :)
declare function _:login(
  $id as xs:string,
  $role as xs:string)
  as empty-sequence()
{
  session:set($_:ID, $id),
  session:set($_:ROLE, $role)
};

(:~
 : Unregisters everything
 :)
declare function _:logout()
  as empty-sequence()
{
  session:close()
};

(:~
 : Returns true if an id is stored for the current session.
 : @param request servlet request
 : @return result of check
 :)
declare function _:logged-in()
  as xs:boolean
{
  boolean(_:id())
};

(:~
 : Returns true if an id with the specified role is stored for the current session.
 : @param role role of the user
 : @return result of check
 :)
declare function _:logged-in-role(
  $role)
  as xs:boolean
{
  boolean(_:id() and (_:role() = $role))
};

(:~
 : Returns the id of the currently logged in user.
 : @return user id
 :)
declare function _:id()
  as xs:string?
{
  session:get($_:ID)
};

(:~
 : Returns the role of the currently logged in user.
 : @return user role 
 :)
declare function _:role()
  as xs:string?
{
  session:get($_:ROLE)
};
