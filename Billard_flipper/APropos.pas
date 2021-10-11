unit APropos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TFPropos = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FPropos: TFPropos;

implementation

{$R *.dfm}

procedure TFPropos.FormClick(Sender: TObject);
begin
     ModalResult := mrOK;
end;

function gabarit(octet : LongInt) : string;
begin
     if octet > 1024 * 1024 * 1024 then
     Result := FloatToStrF(octet/(1024 * 1024 * 1024),ffFixed,15,2) + ' GOctets'
                                   else
     if octet > 1024 * 1024 then
     Result := FloatToStrF(octet/(1024 * 1024),ffFixed,15,2) + ' MOctets'
                            else
     if octet > 1024 then
     Result := FloatToStrF(octet/1024,ffFixed,15,2) + ' KOctets'
                     else
     Result := FloatToStrF(octet/1,ffFixed,15,2) + ' Octets';
end;

procedure TFPropos.FormActivate(Sender: TObject);
var
   Memoire : TMemoryStatus;
   st : string;
begin
     GetDir(0,st); { 0 = Unité en cours }
     Label2.Caption := 'Version du : ' + FormatDateTime('dd mmmm yyyy',
                    FileDateToDateTime(FileAge(st + '\*.exe')));
     GlobalMemoryStatus(Memoire);
     Label4.Caption := Label4.Caption + gabarit(Memoire.dwTotalPhys);
     Label5.Caption := Label5.Caption + Format(' %d %%',[Memoire.dwMemoryLoad]);
end;

end.
