unit UAnime;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Graphics, Menus, Math, ComCtrls;

  procedure FaitReserve;
  procedure Annule;
  procedure Marque;
  procedure Efface;
  procedure Anime;
  procedure ActionneHaut;
  procedure ActionneBas;
  procedure Animation;

implementation

uses
    UFlip, UAvance, Utile, UAnimeThread;

procedure FaitReserve;
var
   i : Byte;
begin
     if qBille = 0 then
     begin
          with FLipper.Billard.Canvas do
          begin
               Brush.Color := Jaune;
               Pen.Color := Noir;
               Rectangle(420 - 5 * 25,550,420,590);
               FloodFill(370,575,Noir,fsBorder);
               Font.Color := Navy;
               Font.Name := 'Colibri';
               Font.Size := 12;
               Font.Style := [fsBold];
               TextOut(300,553,'Partie terminée');
               Font.Size := 8;
               TextOut(300,575,'Autre partie : clic ici');
          end;
          Flipper.PBas.Caption := 'Score final : ' + IntToStr(Total);
     end
     else
     begin
          InitBille;
          with FLipper.Billard.Canvas do
          begin
               Brush.Color := Ciel;
               Pen.Color := Noir;
               i := 5;
               if qBille > i then i := qBille;
               Rectangle(420 - i * 25,550,420,590);
               FloodFill(370,575,Noir,fsBorder);
               Font.Color := Noir;
               Font.Name := 'Colibri';
               Font.Size := 8;
               Font.Style := [fsBold];
               TextOut(305,553,'Choisissez une bille');
               for i := 1 to qBille do Draw(425 - 25 * i,570,Bille.Bmp);
          end;
     end;
end;

procedure Annule;
begin
     Total := Total + Bille.Score;
     Marque;
     Efface;
     Bille.Bmp.Free;
     Bille.Place.Free;
     Sort := True;
     FaitReserve;
end;

procedure Marque;
var
   poly : array[0..4] of TPoint;
begin
     poly[0].X := 169;
     poly[0].Y := 5;
     poly[1].X := 278;
     poly[1].Y := 5;
     poly[2].X := 268;
     poly[2].Y := 61;
     poly[3].X := 176;
     poly[3].Y := 61;
     poly[4].X := 168;
     poly[4].Y := 5;
     with Flipper.Billard.Canvas do
     begin
          Pen.Color := clLime;
          Brush.Color := clLime;
          Polygon(poly);
          Font.Color := clNavy;
          Font.Style := [fsBold];
          Font.Size := 12;
          Font.Name := 'Calibri';
          TextOut(197,3,'SCORES');
          if Bille.Score > 0 then TextOut(185,40,'Bille : ' +
                                       IntToStr(Bille.Score));
          if Total > 0 then TextOut(181,20,'Total : ' +
                            IntToStr(Total));
     end;
     Flipper.Billard.Update;
end;

procedure Efface;
begin
     with Flipper.Billard do
     begin
          Canvas.CopyRect(orig,Bille.Place.Canvas,Bille.rect);
          Update;
     end;
end;

procedure Anime;
var
   Flip : TBitmap;
begin
     Flip := TBitmap.Create;
     with Flip,VAnime do
     begin
          PixelFormat := pf24bit;
          Transparent := True;
          LoadFromResourceName(HInstance,nom);
          FLipper.Billard.Canvas.Draw(Pts.X,Pts.Y,Flip);
          FLipper.Billard.Update;
          Free;
     end;
end;

procedure OteHaut;
begin
     with VAnime do
     begin
          nom := 'HV';
          pts.X := 250;
          pts.Y := 260;
     end;
     Anime;
end;

procedure Haut;
begin
     OteHaut;
     with VAnime do
     begin
          nom := 'HO';
          pts.X := 305;
          pts.Y := 270;
     end;
     Anime;
end;

procedure OteBas;
begin
     with VAnime do
     begin
          nom := 'BV';
          pts.X := 140;
          pts.Y := 500;
     end;
     Anime;
end;

procedure Bas;
begin
     OteBas;
     with VAnime do
     begin
          nom := 'BO';
          pts.X := 155;
          pts.Y := 520;
     end;
     Anime;
end;

procedure ActionneHaut;
begin
     OteHaut;
     with VAnime do
     begin
          nom := 'HF';
          pts.X := 295;
          pts.Y := 267;
     end;
     Anime;
     Sleep(70);
     Haut;
     Fh := True;
end;

procedure ActionneBas;
begin
     OteBas;
     with VAnime do
     begin
          nom := 'BF';
          pts.X := 147;
          pts.Y := 522;
     end;
     Anime;
     Sleep(70);
     Bas;
     Fb := True;
end;

procedure Colore;
begin
     with Flipper.Billard.Picture.Bitmap.Canvas,VAnime do
     begin
          case col of
               1 : Brush.Color := clLime;
               2 : Brush.Color := clRed;
               3 : Brush.Color := clBlue;
               4 : Brush.Color := clYellow;
          end;
          if not Sort then Efface;
          FloodFill(pts.X,pts.Y,clWhite,fsBorder);
          if Bille.ok then Montre;
          Inc(col);
          if col > 4 then col := 1;
     end;
     Flipper.Billard.Update;
end;

procedure Animation;
begin
     //if not Fin then
     with VAnime do
     begin
          case nA of
               1 : begin
                        pts.X := 260;
                        pts.Y := 100;
                        Colore;      // Sépare droite
                        pts.X := 300;
                        pts.Y := 310;
                        Colore;      // I
                        pts.X := 257;
                        pts.Y := 366;
                        Colore;      // L
                        pts.X := 133;
                        pts.Y := 312;
                        Colore;      // 1
                        pts.X := 80;
                        pts.Y := 220;
                        Colore;      // 6
                   end;
              2 : begin
                       pts.X := 207;
                       pts.Y := 100;
                       Colore;      // Sépare gauche
                       pts.X := 277;
                       pts.Y := 320;
                       Colore;      // N
                       pts.X := 330;
                       pts.Y := 310;
                       Colore;      // 100 000
                       pts.X := 109;
                       pts.Y := 298;
                       Colore;      // 2
                       pts.X := 125;
                       pts.Y := 209;
                       Colore;      // Mur orange
                  end;
              3 : begin
                       pts.X := 325;
                       pts.Y := 70;
                       Colore;      // Flêche droite
                       pts.X := 287;
                       pts.Y := 337;
                       Colore;      // B
                       pts.X := 315;
                       pts.Y := 360;
                       Colore;      // 5 000
                       pts.X := 102;
                       pts.Y := 280;
                       Colore;      // 3
                       pts.X := 140;
                       pts.Y := 460;
                       Colore;      // Ressort gauche
                  end;
              4 : begin
                       pts.X := 90;
                       pts.Y := 100;
                       Colore;      // Flêche gauche
                       pts.X := 266;
                       pts.Y := 345;
                       Colore;      // A
                       pts.X := 186;
                       pts.Y := 360;
                       Colore;      // Sortie roue
                       pts.X := 91;
                       pts.Y := 259;
                       Colore;      // 4
                       pts.X := 292;
                       pts.Y := 464;
                       Colore;      // Ressort droit
                  end;
              5 : begin
                       pts.X := 285;
                       pts.Y := 295;
                       Colore;      // P
                       pts.X := 273;
                       pts.Y := 356;
                       Colore;      // L
                       pts.X := 140;
                       pts.Y := 330;
                       Colore;     // Entrée escalier
                       pts.X := 87;
                       pts.Y := 241;
                       Colore;      // 5
                       pts.X := 385;
                       pts.Y := 400;
                       Colore;      // Triangle
                  end;
          end;
          Inc(nA);
          if nA > 5 then nA := 1;
     end;
end;

end.
