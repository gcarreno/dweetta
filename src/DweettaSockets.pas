//      Mozilla Public License.
//
//      The contents of this file are subject to the Mozilla Public License
//      Version 1.1 (the "License"); you may not use this file except in compliance
//      with the License. You may obtain a copy of the License at
//
//      http://www.mozilla.org/MPL/
//
//      Software distributed under the License is distributed on an "AS IS"
//      basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
//      License for the specific language governing rights and limitations under
//      the License.
{*------------------------------------------------------------------------------
  DweettaSockets.pas

  Here we have the decision file for the sockets lib

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaSockets;

{$I Dweetta.inc}
{$IFDEF FPC}
  {$I DweettaSocketsSynapse.pas}
{$ELSE}
  {$IFDEF SOCKS_INDY}
    {$I DweettaSocketsIndy.pas}
  {$ENDIF}
  {$IFDEF SOCKS_SYNAPSE}
    {$I DweettaSocketsSynapse.pas}
  {$ENDIF}
{$ENDIF}
end.
