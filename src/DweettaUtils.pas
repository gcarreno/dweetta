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
{**
  DweettaUtils.pas

  Some utilities for the lib.

  @Author  $Author$
}
unit DweettaUtils;

//  @LastChangedBy $LastChangedBy$
//  @Version $Rev$

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils;

  {**
    Converts a TDateTime into a string compatible with RFC 822, updated by RFC 1123

      @param aDateTime The Date to be converted
      @returns RFC 822,1123 date format
  }
  function DateTimeToInternetTime(const aDateTime: TDateTime): String;
  {**
    Converts a string compatible with RFC 822, updated by RFC 1123 into a TDateTime

      @param aInternetTime The Date to be converted
      @returns TDateTime format
  }
  function InternetTimeToDateTime(const aInternetTime: String): TDateTime;
  {**
    Convenient function to expand a GET param list

      @param aParamList The list of params and values
      @param aInQuery If to translate spaces to + or to %20
      @returns URLencoded params string
  }
  function URLEncodeParams(const aParamList: TStringList; aInQuery: Boolean): String;

implementation

{$IFDEF WIN32}
uses
  Windows;
{$ELSE}

{$ENDIF ~WIN32}

function DateTimeToInternetTime(const aDateTime: TDateTime): String;
{$IFDEF WIN32}
var
  LocalTimeZone: TTimeZoneInformation;
{$ENDIF ~WIN32}
begin
{$IFDEF WIN32}
  // eg. Sun, 06 Nov 1994 08:49:37 GMT  RFC 822, updated by 1123
  Result := FormatDateTime('ddd, dd mmm yyyy hh:nn:ss', aDateTime);
  // Get the Local Time Zone Bias and report as GMT +/-Bias
  GetTimeZoneInformation(LocalTimeZone);
  Result := Result + 'GMT ' + IntToStr(LocalTimeZone.Bias div 60);
{$ELSE}
  Result := 'Sat, 06 Jun 2009 18:00:00 GMT 0000';
{$ENDIF ~WIN32}
end;

function InternetTimeToDateTime(const aInternetTime: String): TDateTime;
begin
  Result := Now;
end;

function URLEncodeParams(const aParamList: TStringList; aInQuery: Boolean): String;
var
  Index, Index1: Integer;
  DirtyString, CleanString: String;
begin
  Result := '';
  CleanString := '';
  for Index := 0 to aParamList.Count -1 do
  begin
    DirtyString := aParamList.ValueFromIndex[Index];
    for Index1 := 1 to Length(DirtyString) do
    begin
      case DirtyString[Index1] of
        'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':begin
          CleanString := CleanString + DirtyString[Index1];
        end;
        ' ':begin
          if aInQuery then
          begin
            CleanString := CleanString + '%20';
          end
          else
          begin
            CleanString := CleanString + '+';
          end;
        end;
      else
        CleanString := CleanString + '%' + IntToHex(Ord(DirtyString[Index1]), 1);
      end;
    end;
    aParamList.ValueFromIndex[Index] := CleanString;
    Result := Result + aParamList[Index] + '&';
  end;
  if aParamList.Count > 0 then
  begin
    SetLength(Result, Length(Result) - 1);
  end;
end;

end.

