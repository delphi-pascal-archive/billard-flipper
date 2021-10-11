unit UFlip;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Graphics, Menus, UAnimeThread, ComCtrls;

type
    TFlipper = class(TForm)
    Timer1: TTimer;
    Billard: TImage;
    BPropos: TPanel;
    BFin: TPanel;
    PBas: TPanel;
    BLancer: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    //procedure VoirApropos;
    procedure BClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
              Shift: TShiftState);
    procedure ReserveClick(Sender: TObject);
    procedure BillardMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Déclarations privées }
  public
  end;

var
   Flipper : TFlipper;
   MAnime : TAnimeThread;

implementation

{$R *.DFM}

uses
    Utile, UAnime, UAvance;

procedure Fond;
// Effet de fondu
begin
     if Flipper.AlphaBlend then
     with Flipper do
     begin
          if nF <= 250 then AlphaBlendValue := AlphaBlendValue - 1
          else
          begin
               Fin := False;
               Close;
          end;
     end;
end;

procedure TFlipper.FormCreate(Sender: TObject);
begin
     with Flipper do
     begin
          Width := 450;
          Height := 660;
          Position := poScreenCenter;
          DoubleBuffered := True;
     end;
     Randomize;
     BPropos.Left := 3;
     BPropos.Top := 3;
     BFin.Left := 355;
     BFin.Top := 3;
     BLancer.Left := 189;
     BLancer.Top := 3;
     nA := 1;
     nF := 0;
     col := 1;
     Am := False;
     Sort := True;
     Fin := False;
     InitBFlip;
     InitBlend;
     Billard.Update;
     PBas.Color := Billard.Canvas.Pixels[100,510];
     InitBGuide;
end;

procedure TFlipper.Timer1Timer(Sender: TObject);
begin
     Inc(nF);
     if Fin then
     begin
          Fond;                 // Sortie fondue
          Animation;            // Animation
     end
     else
     case nF of
          1 : if Bille.ok then Continue; // Déplacement
          2 : if Am then Animation;      // Animation
          else nf := 0;
     end;
end;

procedure TFlipper.BClick(Sender: TObject);
begin
     case (Sender as TPanel).Tag of
          1 : begin
                   BFin.Visible := False;
                   Fin := True;
                   AlphaBlend := True;
                   Timer1.Enabled := True;
                   Timer1.Interval := 20;
              end;
          2 : begin
                   BLancer.Visible := False;
                   Am := True;
                   Sort := True;
                   Keypreview := True;
                   MAnime.Resume;
                   qBille := 5;
                   Total := 0;
                   PBas.Caption := 'Au départ ' + IntToStr(qBille) + ' billes';
                   FaitReserve;
              end;
          3 : VoirApropos;
     end;
end;

procedure TFlipper.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Application.ProcessMessages;
     if Key = VK_RIGHT then ActionneHaut;
     if Key = VK_LEFT then ActionneBas;
end;

procedure TFlipper.ReserveClick(Sender: TObject);
begin
     if qBille = 0 then BClick(BLancer)
     else
     begin
          with VAnime do
          begin
               nom := 'RESERVE';
               pts.X := 257;
               pts.Y := 547;
          end;
          Anime;
          Fh := False;
          Fb := False;
          Sort := False;
          if qBille > 1 then PBas.Caption := 'Reste ' + IntToStr(qBille - 1) + ' billes';
          if qBille = 1 then PBas.Caption := 'Dernière bille';
          Marque;
          Dec(qBille);
          Bille.va := 1;
          Continue;
     end;
end;

procedure TFlipper.BillardMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if (Y > 550) and (Y < 590) then ReserveClick(Sender);
end;

procedure TFlipper.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     MAnime.Suspend;
end;

initialization
      MAnime := TAnimeThread.Create(True);

end.

