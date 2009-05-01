{*------------------------------------------------------------------------------
  DweettaUtils.pas

  Some utilities for the lib.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaUtils;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils;

  function DateTimeToInternet(aDateTime: TDateTime): String;

implementation

uses
  Windows;

function DateTimeToInternet(aDateTime: TDateTime): String;
var
  LocalTimeZone: TTimeZoneInformation;
begin
  // eg. Sun, 06 Nov 1994 08:49:37 GMT  RFC 822, updated by 1123
  Result := FormatDateTime('ddd, dd mmm yyyy hh:nn:ss', aDateTime);
  // Get the Local Time Zone Bias and report as GMT +/-Bias
  GetTimeZoneInformation(LocalTimeZone);
  Result := Result + 'GMT ' + IntToStr(LocalTimeZone.Bias div 60);
end;

end.

