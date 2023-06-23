unit ip_address;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, JwaIpTypes, jwaiphlpapi, Windows, fphttpclient, opensslsockets;

type

  TLocalNetworkInfo = record
    fixedIpAddress: boolean;
    Description: string;
    Name: string;
    IPAddress: string;
    IPSubnetMask: string;
    MAC: string;
    MACAddress: string;
    Gateway: string;
    DHCPEnabled: boolean;
    DHCP: string;
    HaveWINS: boolean;
    PrimaryWINS: string;
    SecondaryWINS: string;
  end;
  TLocalNetworksInfos = array of TLocalNetworkInfo;

  { TNetworkAddressHelper }

  TNetworkAddressHelper = class(TObject)
  public
    class function getLocalIpAddresses(out info: TLocalNetworksInfos): Boolean;
    class function getExternalIpAddress(): String;
  end;

implementation

{ TNetworkAddressHelper }

class function TNetworkAddressHelper.getLocalIpAddresses(out info: TLocalNetworksInfos): Boolean;
var
  pAdapterInfo: PIP_ADAPTER_INFO;
  AdapterInfo: IP_ADAPTER_INFO;
  BufLen: DWORD;
  strMAC: String;
  i: Integer;
begin
  BufLen:= sizeof(AdapterInfo);
  pAdapterInfo:= @AdapterInfo;
  SetLength(info, 0);
  GetAdaptersInfo(nil, BufLen); // get the length
  pAdapterInfo:= AllocMem(BufLen);
  try
    Result := GetAdaptersInfo(pAdapterInfo, BufLen) = ERROR_SUCCESS;
    if (Result) then
    begin
      SetLength(info, 0);
      while (pAdapterInfo <> nil) do
      begin
        {
        strings.Add('Description: ' + pAdapterInfo^.Description);
        strings.Add('Name: ' + pAdapterInfo^.AdapterName);
        strMAC := '';
        for I := 0 to pAdapterInfo^.AddressLength - 1 do
            strMAC := strMAC + '-' + IntToHex(pAdapterInfo^.Address[I], 2);
        Delete(strMAC, 1, 1);
        strings.Add('MAC address: ' + strMAC);
        strings.Add('IP address: ' + pAdapterInfo^.IpAddressList.IpAddress.S);
        strings.Add('IP subnet mask: ' + pAdapterInfo^.IpAddressList.IpMask.S);
        strings.Add('Gateway: ' + pAdapterInfo^.GatewayList.IpAddress.S);
        strings.Add('DHCP enabled: ' + IntTOStr(pAdapterInfo^.DhcpEnabled));
        strings.Add('DHCP: ' + pAdapterInfo^.DhcpServer.IpAddress.S);
        strings.Add('Have WINS: ' + BoolToStr(pAdapterInfo^.HaveWins,True));
        strings.Add('Primary WINS: ' + pAdapterInfo^.PrimaryWinsServer.IpAddress.S);
        strings.Add('Secondary WINS: ' + pAdapterInfo^.SecondaryWinsServer.IpAddress.S);
        }

        if not AnsiSameText('0.0.0.0', pAdapterInfo^.IpAddressList.IpAddress.S) then
        begin
          setLength(info, length(info)+1);
          info[high(info)].fixedIpAddress := pAdapterInfo^.DhcpEnabled = 0;
          info[high(info)].Description   := pAdapterInfo^.Description;
          info[high(info)].Name          := pAdapterInfo^.AdapterName;
          info[high(info)].IPAddress     := pAdapterInfo^.IpAddressList.IpAddress.S;
          info[high(info)].IPSubnetMask  := pAdapterInfo^.IpAddressList.IpMask.S;
          info[high(info)].Gateway       := pAdapterInfo^.GatewayList.IpAddress.S;
          info[high(info)].DHCPEnabled   := pAdapterInfo^.DhcpEnabled = 0;
          info[high(info)].DHCP          := pAdapterInfo^.DhcpServer.IpAddress.S ;
          info[high(info)].HaveWINS      := pAdapterInfo^.HaveWins;
          info[high(info)].PrimaryWINS   := pAdapterInfo^.PrimaryWinsServer.IpAddress.S;
          info[high(info)].SecondaryWINS := pAdapterInfo^.SecondaryWinsServer.IpAddress.S;

          strMAC := '';
          for I := 0 to pAdapterInfo^.AddressLength - 1 do
              strMAC := strMAC + '-' + IntToHex(pAdapterInfo^.Address[I], 2);
          Delete(strMAC, 1, 1);

          info[high(info)].MACAddress    := strMAC;
        end;

        pAdapterInfo := pAdapterInfo^.Next;
      end;
    end;

  finally
    Dispose(pAdapterInfo);
  end;
end;

class function TNetworkAddressHelper.getExternalIpAddress: String;
var
  HTTPClient: TFPHTTPClient;
  IP: string;

begin
  HTTPClient := TFPHTTPClient.Create(nil);
  try
    IP := HTTPClient.Get('https://api.ipify.org');

    Result := IP;
  finally
    HTTPClient.Free;
  end;
end;

end.

