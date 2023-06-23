# IpAddressAndNetworkInfoPascal

IpAddressAndNetworkInfoPascal is an Open Source project that aims to produce return a IP Address, external ou local, just been and simple unit for ObjectPascal (Lazarus, Delphi, etc).

It was just tested in Windows. Not tested in linux.

## How to use

Just add the unit `ip_address.pas` to project.
  - ``Project -> Add to Project`` and then locate and choose the file.

### How to use | Example

Just call the method `TNetworkAddressHelper.getExternalIpAddress()` or `TNetworkAddressHelper.getLocalIpAddresses(out info: TLocalNetworksInfos)` to get the network info.

Open example at `example` folder, or the given example above:

```pascal
program getIpAddress;

uses
  Classes, SysUtils, ip_address, Variants;

var
  netInfos: TLocalNetworksInfos;
  i: integer;

begin
  writeln('=== External IP Address ===');
  try
    writeln(TNetworkAddressHelper.getExternalIpAddress());
  except
    on e: Exception do
      writeln('ERROR: ' + e.Message);
  end;
  writeln('');
  writeln('=== Local Network Infos ===');
  writeln('');

  if (TNetworkAddressHelper.getLocalIpAddresses(netInfos)) then
    for i:=low(netInfos) to high(netInfos) do
        writeln(netInfos[i].IPAddress + ' | Adapter: ' +netInfos[i].Description); 
  
  readln;
end.
```

### Extracted Data

- External Just get the IP Adress from `https://api.ipify.org`

- Local Network Info Example:
  - fixedIpAddress   = True
  - Description      = VirtualBox Host-Only Ethernet Adapter
  - Name             = {874E7498-45F5-474E-9556-9170211CBF2F}
  - IPAddress        = 192.168.56.1
  - IPSubnetMask     = 255.255.255.0
  - MAC              = 
  - MACAddress       = 0A-00-27-00-00-08
  - Gateway          = 0.0.0.0
  - DHCPEnabled      = True
  - DHCP             = 
  - HaveWINS         = False
  - PrimaryWINS      = 
  - SecondaryWINS    = 
  
## License

This software is open source, licensed under the The MIT License (MIT). See [LICENSE](https://github.com/martinusso/log4pascal/blob/master/LICENSE) for details.
