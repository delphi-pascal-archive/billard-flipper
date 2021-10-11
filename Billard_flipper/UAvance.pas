unit UAvance;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Graphics, Menus, Math, ComCtrls;
  procedure Montre;
  procedure Continue;
  procedure VoirApropos;

implementation

uses
    UFlip, Utile, APropos, UAnime;

function Tirage(i : Integer) : Integer;
begin
     Result := Random(i) + 1;
end;

procedure Montre;
begin
     if not Sort then Efface;
     with Bille,orig do
     begin
          Left := but.X - rayon;
          Top := but.Y - rayon;
          Right := but.X + rayon;
          Bottom := but.Y + rayon;
     end;
     Bille.Place.Canvas.CopyRect(Bille.rect,BFlip.Canvas,orig);
     Flipper.Billard.Canvas.Draw(Bille.but.X - rayon,
                                 Bille.but.Y - rayon,
                                 Bille.Bmp);
     Flipper.Billard.Update;
end;

procedure Ligne;
var
   dx,dy,dh,avt : Double;
   i : Integer;
begin
     dh := Hypot(Bille.but.X - Bille.dep.X,Bille.but.Y - Bille.dep.Y);
     if dh <> 0 then
     begin
          dx := (Bille.but.X - Bille.dep.X) / dh;
          dy := (Bille.but.Y - Bille.dep.Y) / dh;
          i := 1;
          while i < Trunc(dh) do
          begin
               avt := i * dx;
               Bille.but.X := Bille.dep.X + Trunc(avt);
               avt := i * dy;
               Bille.but.Y := Bille.dep.Y + Trunc(avt);
               Montre;
               Inc(i);
          end;
     end;
     Bille.dep := Bille.but;
end;

procedure Courbe;
var
   i,quart : Byte;
   x,y,dx,dy : Integer;

   procedure Bouge;
   begin
        Bille.but.X := Bille.but.X + x;
        Bille.but.Y := Bille.but.Y + y;
        Montre;
   end;

   function Trouve : Byte;
   var
      cl : Integer;
   begin
        Result := 1;
        cl := BGuide.Canvas.Pixels[Bille.but.X + x,Bille.but.Y + y];
        case cl of
             Noir : Result := 0; // Sortie
             Gris : Result := 1; // Fond
             Blanc : Result := 2;// Tracé
             Navy : if Bille.choix > 2 then Result := 0;
             Marron : quart := 1;// X\ Y\
             Bleu : quart := 2;  // X\ Y/
             Vert : quart := 3;  // X/ Y/
             Jaune : quart := 4; // X/ Y\
        end;
   end;

   procedure Progresse;
   begin
        Inc(x,dx);
        if x = dx * 4 then
        begin
             x := 0;
             Inc(y,dy);
        end;
   end;

begin
     x := 0;
     y := 0;
     Trouve;
     if quart > 0 then
     repeat
           x := 0;
           y := 0;
           i := 1;
           while i = 1 do
           begin
                case quart of
                     1 : begin
                              dx := - 1;
                              dy := - 1;
                         end;
                     2 : begin
                              dx := - 1;
                              dy := 1;
                         end;
                     3 : begin
                              dx := 1;
                              dy := 1;
                         end;
                     4 : begin
                              dx := 1;
                              dy := - 1;
                         end;
                end;
                if (y = 0) and (x = 0) then x := dx;
                i := Trouve;
                if i = 1 then Progresse;
           end;
           if i = 2 then Bouge;
     until i = 0;
     Bouge;
     Bille.dep := Bille.but;
end;

procedure Champ(X,Y : Integer);
var
   Flip,
   Place : TBitmap;
   rect,Arect : TRect;
begin
     Place := TBitmap.Create;
     with Place do
     begin
          Width := 32;
          Height := 32;
          PixelFormat := pf24bit;
     end;
     with Arect do
     begin
          Left := X;
          Top := Y;
          Right := X + 32;
          Bottom := Y + 32;
     end;
     with rect do
     begin
          Left := 0;
          Top := 0;
          Right := 32;
          Bottom := 32;
     end;
     Place.Canvas.CopyRect(rect,BFlip.Canvas,Arect);
     Flip := TBitmap.Create;
     with Flip do
     begin
          PixelFormat := pf24bit;
          Transparent := True;
          LoadFromResourceName(HInstance,'Rouge');
          FLipper.Billard.Canvas.Draw(X,Y,Flip);
     end;
     FLipper.Billard.Update;
     Sleep(200);
     with Flip do
     begin
          LoadFromResourceName(HInstance,'Jaune');
          FLipper.Billard.Canvas.Draw(X,Y,Flip);
     end;
     FLipper.Billard.Update;
     Sleep(200);
     with Flip do
     begin
          LoadFromResourceName(HInstance,'Bleu');
          FLipper.Billard.Canvas.Draw(X,Y,Flip);
          Free;
     end;
     FLipper.Billard.Update;
     Sleep(200);
     with Flipper.Billard do
     begin
          Canvas.CopyRect(Arect,Place.Canvas,rect);
          Update;
     end;
     Place.Free;
end;

procedure Sortie;
// 30
begin
     Bille.but.X := 218;
     Bille.but.Y := 575;
     Ligne;
     Sort := True;
     Efface;
     Bille.but.X := 412;
     Bille.but.Y := 479;
     Montre;
     Annule;
end;

procedure ChampignonM;
// 26
begin
     Bille.but.X := 199;
     Bille.but.Y := 214;
     Ligne;
     Champ(189,216);
     Inc(Bille.score,100);
     Marque;
     Bille.ok := True;
     Bille.va := 8;          // RosaceG
end;

procedure MurVert;
// 25
begin
     Bille.but.X := 329;
     Bille.but.Y := 188;
     Ligne;
     Bille.ok := True;
     Bille.va := 19;         // ChampignonD
end;

procedure Mur25;
// 24
begin
     Bille.but.X := 128;
     Bille.but.Y := 371;
     Ligne;
     Efface;
     Bille.but.X := 134;
     Bille.but.Y := 345;
     Sleep(150);
     Montre;
     Bille.but.X := 374;
     Bille.but.Y := 380;
     Ligne;
     Inc(Bille.score,1000);
     Marque;
     Bille.ok := True;
     Bille.va := 17;         // Triangle
end;

procedure FlipperBas;
// 23
begin
     Bille.but.X := 195;
     Bille.but.Y := 530;
     Ligne;
     if Fb then
     begin
          Fb := False;
          if BGuide.Canvas.Pixels[Bille.but.X,Bille.but.Y] = Ciel then
          begin
               Bille.choix := Tirage(2);
               Bille.ok := True;
               case Bille.choix of
                    1 : Bille.va := 11;   // Roue
                    2 : Bille.va := 25;   // MurVert
               end;
          end;
          if BGuide.Canvas.Pixels[Bille.but.X,Bille.but.Y] = Rose then
          begin
               Bille.choix := Tirage(3);
               case Bille.choix of
                    1 : begin
                             Bille.ok := True;
                             Bille.va := 11;     // Roue
                        end;
                    2 : begin
                             Bille.ok := True;
                             Bille.va := 24;     // Mur25
                        end;
                    3 : begin
                             Bille.but.X := 151;
                             Bille.but.Y := 354;
                             Ligne;
                             Courbe;
                             Bille.ok := True;
                             Bille.va := 15;     // EscalierRouge
                        end;
               end;
          end;
     end
     else
     begin
          Bille.ok := True;
          Bille.va := 30;    // Sortie
     end;
end;

procedure ChampignonG;
// 22
begin
     Bille.but.X := 183;
     Bille.but.Y := 147;
     Ligne;
     Inc(Bille.score,100);
     Marque;
     Champ(170,159);
     Bille.ok := True;
     Bille.va := 14;         //RosaceM
end;

procedure MurOrange;
// 21
begin
     Bille.but.X := 122;
     Bille.but.Y := 203;
     Ligne;
     Bille.choix := Tirage(2);
     Inc(Bille.score,2000);
     Marque;
     Bille.ok := True;
     case Bille.choix of
          1 : Bille.va := 26;      // ChampignonM
          2 : Bille.va := 19;      // ChampignonD
     end;
end;

procedure FlipperHaut;
// 20
begin
     Bille.but.X := 319;
     Bille.but.Y := 275;
     Ligne;
     if Fh then
     begin
          Fh := False;
          if BGuide.Canvas.Pixels[Bille.but.X,Bille.but.Y] = Mauve then
          begin
               Bille.choix := Tirage(2);
               Bille.ok := True;
               case Bille.choix of
                    1 : Bille.va := 8;      // Rosace
                    2 : Bille.va := 19;     // ChampignonsD
               end;
          end;
     end
     else
     begin
          Bille.ok := True;
          Bille.va := 13;                   // RessortDroit
     end;
end;

procedure ChampignonD;
// 19
begin
     Bille.but.X := 285;
     Bille.but.Y := 195;
     Ligne;
     Champ(242,170);
     Bille.but.X := 305;
     Bille.but.Y := 290;
     Ligne;
     Inc(Bille.score,100);
     Marque;
     Bille.ok := True;
     Bille.va := 20;        //FlipperHaut;
end;

procedure RessortGauche;
// 18
begin
     Bille.but.X := 166;
     Bille.but.Y := 450;
     Ligne;
     Inc(Bille.score,100);
     Marque;
     Bille.choix := Tirage(2);
     case Bille.choix of
          1 : begin
                   Courbe;
                   Bille.but.X := 285;
                   Bille.but.Y := 324;
                   Ligne;
                   Courbe;
                   Bille.ok := True;
                   Bille.va := 19;               // ChampignonD
              end;
          2 : begin
                   Bille.but.X := 151;
                   Bille.but.Y := 354;
                   Ligne;
                   Courbe;
                   Bille.ok := True;
                   Bille.va := 15;              // EscalierRouge
              end;
     end;
end;

procedure Triangle;
// 17
begin
     Bille.but.X := 372;
     Bille.but.Y := 385;
     Ligne;
     Inc(Bille.score,500);
     Marque;
     Bille.choix := Tirage(3);
     case Bille.choix of
          1 : begin
                   Bille.ok := True;
                   Bille.va := 7;        // EcalierVert
              end;
          2 : begin
                   Bille.ok := True;
                   Bille.va := 11;       // Roue
              end;
          3 : begin
                   Bille.but.X := 414;
                   Bille.but.Y := 268;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 9;       // Retour
              end;
     end;
end;

procedure Tube;
// 16
begin
     Bille.but.X := 167;
     Bille.but.Y := 133;
     Montre;
     Courbe;
     Bille.ok := True;
     Bille.va := 20;            // FlipperHaut
end;

procedure EchelleRouge;
// 15
begin
     Inc(Bille.score,2000);
     Marque;
     Bille.but.X := 151;
     Bille.but.Y := 346;
     Ligne;
     Courbe;
     Bille.choix := Tirage(2);
     case Bille.choix of
          1 : begin
                   Bille.ok := True;
                   Bille.va := 8;            // RosaceD
              end;
          2 : begin
                   Bille.ok := True;
                   Bille.va := 16;           // Tube
              end;
     end;
end;

procedure RosaceM;
// 14
begin
     Bille.but.X := 234;
     Bille.but.Y := 108;
     Ligne;
     Inc(Bille.score,300);
     Marque;
     Bille.choix := Tirage(2);
     case Bille.choix of
          1 : begin
                   Bille.but.X := 188;
                   Bille.but.Y := 74;
                   Ligne;
                   Efface;
                   Sleep(300);
                   Bille.ok := True;
                   Bille.va := 3;                // Jackpot
              end;
          2 : begin
                   Bille.but.X := 196;
                   Bille.but.Y := 161;
                   Ligne;
                   Bille.but.X := 245;
                   Bille.but.Y := 183;
                   Ligne;
                   Bille.but.X := 127;
                   Bille.but.Y := 233;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 21;               // Mur orange
              end;
     end;
end;

procedure RessortDroit;
// 13
begin
     Bille.but.X := 271;
     Bille.but.Y := 440;
     Ligne;
     Inc(Bille.score,200);
     Marque;
     Bille.choix := Tirage(5);
     case Bille.choix of
          1 : begin
                   Bille.ok := True;
                   Bille.va := 11;      // Roue
              end;
          2 : begin
                   Bille.but.X := 243;
                   Bille.but.Y := 203;
                   Ligne;
                   Bille.but.X := 124;
                   Bille.but.Y := 206;
                   Ligne;
                   Bille.but.X := 187;
                   Bille.but.Y := 111;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 12;      // RosaceG
              end;
          3 : begin
                   Bille.but.X := 320;
                   Bille.but.Y := 325;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 15;      // EchelleRouge
              end;
          4 : begin
                   Bille.ok := True;
                   Bille.va := 24;      // Mur25;
              end;
          5 : begin
                   Bille.but.X := 100;
                   Bille.but.Y := 390;
                   Ligne;
                   Bille.but.X := 84;
                   Bille.but.Y := 430;
                   Ligne;
                   Bille.but.X := 85;
                   Bille.but.Y := 488;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 30;      // Sortie;
              end;
     end;
end;

procedure RosaceG;
// 12
begin
     Inc(Bille.score,300);
     Marque;
     Bille.but.X := 185;
     Bille.but.Y := 109;
     Ligne;
     Bille.choix := Tirage(3);
     case Bille.choix of
          1 : begin
                   Bille.but.X := 350;
                   Bille.but.Y := 430;
                   Ligne;
                   Bille.but.X := 350;
                   Bille.but.Y := 490;
                   Ligne;
                   Bille.but.X := 220;
                   Bille.but.Y := 585;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 30;      // Sortie
              end;
          2 : begin
                   Bille.ok := True;
                   Bille.va := 21;      // MurOrange
              end;
          3 : begin
                   Bille.ok := True;
                   Bille.va := 22;      // ChampignonG
              end;
     end;
end;

procedure Roue;
//  11
begin
     Bille.but.X := 231;
     Bille.but.Y := 344;
     Ligne;
     Efface;
     Sleep(700);
     Bille.but.X := 175;
     Bille.but.Y := 340;
     Bille.dep := Bille.but;
     Montre;
     Inc(Bille.score,500);
     Marque;
     Bille.choix := Tirage(4);
     case Bille.choix of
          1 : begin
                   Bille.but.X := 270;
                   Bille.but.Y := 444;
                   Ligne;
                   Bille.but.X := 243;
                   Bille.but.Y := 203;
                   Ligne;
                   Bille.but.X := 124;
                   Bille.but.Y := 206;
                   Ligne;
                   Bille.but.X := 187;
                   Bille.but.Y := 111;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 12;      // RosaceG
              end;
          2 : begin
                   Bille.ok := True;
                   Bille.va := 13;      // RessortDroit
              end;
          3 : begin
                   Bille.but.X := 165;
                   Bille.but.Y := 447;
                   Ligne;
                   Bille.but.X := 338;
                   Bille.but.Y := 207;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 18;      // RessortGauche
              end;
          4 : begin
                   Bille.ok := True;
                   Bille.va := 23;      // FlipperBas
              end;
     end;
end;

procedure Tobogan;
// 10
begin
     Bille.but.X := 167;
     Bille.but.Y := 47;
     Ligne;
     Courbe;
     Efface;
     Sleep(200);
     Bille.but.X := 167;
     Bille.but.Y := 133;
     Montre;
     Courbe;
     Inc(Bille.score,100);
     Marque;
     Bille.ok := True;
     Bille.va := 20;        //FlipperHaut;
end;

procedure Retour;
// 9
begin
     Bille.but.X := 412;
     Bille.but.Y := 209;
     Ligne;
     Bille.but.X := 412;
     Bille.but.Y := 309;
     Ligne;
     Courbe;
     Bille.dep := Bille.but;
     Bille.but.X := 330;
     Bille.but.Y := 398;
     Ligne;
     Courbe;
     Bille.but.X := 317;
     Bille.but.Y := 476;
     Ligne;
     Inc(Bille.score,100);
     Marque;
     Bille.but.X := 248;
     Bille.but.Y := 524;
     Ligne;
     Bille.ok := True;
     Bille.va := 23;             // FlipperBas
end;

procedure RosaceD;
// 8
begin
     Inc(Bille.score,300);
     Marque;
     Bille.choix := Tirage(2);
     case Bille.choix of
          1 : begin
                   Bille.but.X := 264;
                   Bille.but.Y := 83;
                   Ligne;
                   Bille.but.X := 369;
                   Bille.but.Y := 57;
                   Ligne;
                   Bille.but.X := 405;
                   Bille.but.Y := 127;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 9;            // Retour
              end;
          2 : begin
                   Bille.but.X := 265;
                   Bille.but.Y := 160;
                   Ligne;
                   Bille.but.X := 235;
                   Bille.but.Y := 110;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 14;           // RosaceM
              end;
     end;
end;

procedure EscalierVert;
// 7
begin
     Inc(Bille.score,2000);
     Marque;
     Bille.but.X := 352;
     Bille.but.Y := 309;
     Ligne;
     Courbe;
     Bille.but.X := 300;
     Bille.but.Y := 150;
     Ligne;
     Bille.choix := Tirage(2);
     case Bille.choix of
          1 : begin
                   Bille.but.X := 281;
                   Bille.but.Y := 189;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 19;        // ChampignonD
              end;
          2 : begin
                   Bille.ok := True;
                   Bille.va := 20;        //FlipperHaut;
              end;
     end;
end;

procedure TrouDroit;
// 6
begin
     Inc(Bille.score,500);
     Marque;
     Bille.but.X := 351;
     Bille.but.Y := 325;
     Ligne;
     Sleep(200);
     Bille.choix := Tirage(3);
     case Bille.choix of
          1 : begin
                   Bille.ok := True;
                   Bille.va := 7;           // Escalier vert
              end;
          2 : begin
                   Bille.ok := True;
                   Bille.va := 11;           // Roue
              end;
          3 : begin
                   Bille.but.X := 166;
                   Bille.but.Y := 449;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 18;           // RessordGauche
              end;
     end;
end;

procedure TrouGauche;
// 5
begin
     Inc(Bille.score,500);
     Marque;
     Bille.but.X := 32;
     Bille.but.Y := 433;
     Ligne;
     Sleep(200);
     with VAnime do
     begin
          nom := 'Jackpot';
          pts.X := 2;
          pts.Y := 258;
          Anime;
     end;
     Bille.choix := Tirage(3);
     case Bille.choix of
          1 : begin
                   Courbe;
                   Bille.ok := True;
                   Bille.va := 6;      // TrouDroit
              end;
          2 : begin
                   Bille.but.X := 38;
                   Bille.but.Y := 429;
                   Ligne;
                   Courbe;
                   Bille.ok := True;
                   Bille.va := 13;     // RessortDroit
              end;
          3 : begin
                   Bille.but.X := 86;
                   Bille.but.Y := 393;
                   Ligne;
                   Bille.ok := True;
                   Bille.va := 17;     // Triangle;
              end;
     end;
end;

procedure Loterie;
// 4
var
   i : Byte;
begin
     Bille.but.X := 33;
     Bille.but.Y := 246;
     Ligne;
     Efface;
     Flipper.Billard.Update;
     with Flipper.Billard.Picture.Bitmap.Canvas,VAnime do
     begin
          nom := 'Jackp2';
          pts.X := 17;
          pts.Y := 295;
          Anime;
          pts.X := 36;
          pts.Y := 292;
          Anime;
          pts.X := 52;
          pts.Y := 293;
          Anime;
          for i := 1 to 20 do
          begin
               if i mod 2 = 0 then nom := 'Jackp1'
                              else nom := 'Jackp2';
               pts.X := 17;
               pts.Y := 295;
               Anime;
               if i mod 2 = 0 then Brush.Color := clRed
                              else Brush.Color := clNavy;
               FloodFill(24,306,clBlack,fsBorder);
               pts.X := 35;
               pts.Y := 291;
               Anime;
               if i mod 2 = 0 then Brush.Color := clNavy
                              else Brush.Color := clYellow;
               FloodFill(40,302,clBlack,fsBorder);
               pts.X := 52;
               pts.Y := 293;
               Anime;
               if i mod 2 = 0 then Brush.Color := clYellow
                              else Brush.Color := clRed;
               FloodFill(56,302,clBlack,fsBorder);
               Flipper.Billard.Update;
               Sleep(100);
          end;
          nom := 'Jackpot';
          pts.X := 2;
          pts.Y := 258;
          Anime;
          i := Tirage(9);
          Inc(Bille.score,i * 100);
          Brush.Color := Gris;
          Font.Name := 'Calibri';
          Font.Color := Noir;
          Font.Style := [fsBold];
          Font.Size := 13;
          TextOut(22,296,IntToStr(i));
          Flipper.Billard.Update;
          Marque;
          Bille.but.Y := 357;
          Bille.dep := Bille.but;
          Montre;
     end;
     Bille.ok := True;
     Bille.va := 5;      // TrouGauche
end;

procedure JackPot;
// 3
begin
     Bille.but.X := 108;
     Bille.but.Y := 45;
     Ligne;
     Courbe;
     Bille.ok := True;
     Bille.va := 4;          // Loterie
end;

procedure Virage;
// 2
begin
     Bille.choix := Tirage(4);
     case Bille.choix of
          1,2 : begin
                     Bille.but.X := 412;
                     Bille.but.Y := 144;
                     Ligne;
                     Courbe;
                     Bille.but.X := 285;
                     Bille.but.Y := 40;
                     Ligne;
                     Efface;
                     Sleep(600);
                     if Bille.choix = 1 then
                     begin
                          Bille.but.X := 156;
                          Bille.but.Y := 43;
                          Bille.dep := Bille.but;
                          Montre;
                          Bille.ok := True;
                          Bille.va := 3;            // JackPot
                     end
                     else
                     begin
                          Bille.but.X := 160;
                          Bille.but.Y := 55;
                          Bille.dep := Bille.but;
                          Montre;
                          Bille.ok := True;
                          Bille.va := 10;            // Tobogan
                     end;
                end;
            3,4 : begin
                       Bille.but.X := 412;
                       Bille.but.Y := 144;
                       Ligne;
                       if Bille.choix = 3 then
                       begin
                            Bille.but.X := 349;
                            Bille.but.Y := 53;
                            Ligne;
                            Courbe;
                            Bille.ok := True;
                            Bille.va := 19;                 // ChampignonD
                       end
                       else
                       begin
                            Courbe;
                            Bille.but.X := 335;
                            Bille.but.Y := 49;
                            Ligne;
                            Courbe;
                            Bille.ok := True;
                            Bille.va := 8;                  // RosaceD
                       end;
                end;
     end;
end;

procedure Tir;
// 1
begin
     Flipper.Update;
     Sleep(500);
     with VAnime do
     begin
          nom := 'TIR';
          pts.X := 397;
          pts.Y := 488;
     end;
     Anime;
     Bille.but.Y := 490;
     Bille.but.X := 412;
     Montre;
     Sleep(150);
     with VAnime do
     begin
          nom := 'TV';
          pts.X := 397;
          pts.Y := 448;
     end;
     Anime;
     Bille.choix := Tirage(2);
     Bille.ok := True;
     case Bille.choix of
          1 : Bille.va := 2;            // Virage;
          2 : Bille.va := 9;            // Retour
     end;
end;

procedure Continue;
begin
     Bille.ok := False;
     case Bille.va of
          1 : Tir;
          2 : Virage;
          3 : JackPot;
          4 : Loterie;
          5 : TrouGauche;
          6 : TrouDroit;
          7 : EscalierVert;
          8 : begin
                   Sleep(200);
                   RosaceD;
              end;
          9 : Retour;
         10 : Tobogan;
         11 : Roue;
         12 : begin
                   Sleep(200);
                   RosaceG;
              end;
         13 : RessortDroit;
         14 : begin
                   Sleep(200);
                   RosaceM;
              end;
         15 : EchelleRouge;
         16 : Tube;
         17 : Triangle;
         18 : RessortGauche;
         19 : ChampignonD;
         20 : FlipperHaut;
         21 : MurOrange;
         22 : ChampignonG;
         23 : FlipperBas;
         24 : Mur25;
         25 : MurVert;
         26 : ChampignonM;
         30 : Sortie;
     end;
end;

procedure VoirApropos;
begin
     with TFPropos.Create(Application) do // Apropos
     try
        ShowModal;
        finally
        Free;
     end;
end;

end.
