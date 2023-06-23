unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ip_address, Variants;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    memoStr: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public
    procedure getNetworkInfo(aCompleteInfo: Boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  getNetworkInfo(False);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  getNetworkInfo(true);
end;

procedure TForm1.getNetworkInfo(aCompleteInfo: Boolean);
var
  netInfos: TLocalNetworksInfos;
  i: integer;
begin
  memoStr.lines.add('');
  memoStr.lines.add('=== External IP Address ===');
  memoStr.lines.add('');
  try
  memoStr.lines.add(TNetworkAddressHelper.getExternalIpAddress());

  except
    on e: Exception do
      memoStr.lines.add('ERROR: ' + e.Message);
  end;
  memoStr.lines.add('');
  memoStr.lines.add('=== Local Network Infos ===');
  memoStr.lines.add('');

  if (TNetworkAddressHelper.getLocalIpAddresses(netInfos)) then
  begin
    for i:=low(netInfos) to high(netInfos) do
    begin
      if (aCompleteInfo) then
      begin
        memoStr.lines.add(Format('Adapter: %s', [netInfos[i].Description]));
        memoStr.lines.add(Format(' - fixedIpAddress   = %s', [VarToStr(netInfos[i].fixedIpAddress)]));
        memoStr.lines.add(Format(' - Description      = %s', [netInfos[i].Description]));
        memoStr.lines.add(Format(' - Name             = %s', [netInfos[i].Name]));
        memoStr.lines.add(Format(' - IPAddress        = %s', [netInfos[i].IPAddress]));
        memoStr.lines.add(Format(' - IPSubnetMask     = %s', [netInfos[i].IPSubnetMask]));
        memoStr.lines.add(Format(' - MAC              = %s', [netInfos[i].MAC]));
        memoStr.lines.add(Format(' - MACAddress       = %s', [netInfos[i].MACAddress]));
        memoStr.lines.add(Format(' - Gateway          = %s', [netInfos[i].Gateway]));
        memoStr.lines.add(Format(' - DHCPEnabled      = %s', [VarToStr(netInfos[i].DHCPEnabled)]));
        memoStr.lines.add(Format(' - DHCP             = %s', [netInfos[i].DHCP]));
        memoStr.lines.add(Format(' - HaveWINS         = %s', [VarToStr(netInfos[i].HaveWINS)]));
        memoStr.lines.add(Format(' - PrimaryWINS      = %s', [netInfos[i].PrimaryWINS]));
        memoStr.lines.add(Format(' - SecondaryWINS    = %s', [netInfos[i].SecondaryWINS]));
        memoStr.lines.add('');
      end
      else
        memoStr.lines.add(Format('%s (Adapter: %s)', [netInfos[i].IPAddress, netInfos[i].Description]));
    end;
  end;
end;

end.

