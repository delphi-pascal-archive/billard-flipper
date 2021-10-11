unit Utile;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Graphics, Menus, ComCtrls;

  procedure MessageVue(st : string);
  procedure InitBille;
  procedure InitBGuide;
  procedure InitBlend;
  procedure InitBFlip;

const
     rayon = 10;
     Blanc = 16777215;
     Noir = 0;
     Bleu = 12623872;
     Jaune = 65535;
     Gris = 8421504;
     Marron = 128;
     Navy = 12599360;
     Vert = 4243488;
     Rose = 12624096;
     Mauve = 12599456;
     Ciel = 15780518;
     //Fuchsia = 4202720;
     //Lime = 57536;
     //Orange = 4227296;}
type
    TBille = record
                   Place,              // Bitmap de l'emplacement
                   Bmp : TBitmap;      // Bitmap de la bille
                   rect : TRect;       // Rectangle destination
                   score : Integer;    // Score de la bille
                   ok : Boolean;       // Bille en attente
                   va,                 // Index d'avancement
                   choix : Byte;       // Force choisie du tir
                   dep,                // Position de départ
                   but : TPoint;       // Destination de la bille
              end;
    TAnime = record
                   nom : string;       // Nom du fichier
                   pts : TPoint;       // Position
             end;
var
   BlendFunc : TBlendFunction;         // Pour sortie fondue
   Bille : TBille;
   VAnime : TAnime;
   Total : Integer; // Score de la partie

   BFlip,           // Dessin du billard
   BGuide : TBitmap;// Dessin du tracé
   orig : TRect;    // Rectangle origine

   col,             // Type de coloration
   qBille,          // Quantité de billes au départ
   nF,              // Temporisation pour fondu
   nA : Byte;       // Temporisation animation

   Fin,             // Programme terminé
   Sort,            // Bille sortie du billard
   Am,              // Animation en cours
   Fh,              // Flip haut
   Fb : Boolean;    // Flip bas gauche

implementation

uses UFlip, UAnime;

procedure MessageVue(st : string);
begin
     if MessageDlgPos(st + #13 + 'Arrêt immédiat ?',mtConfirmation,
        [mbYes,mbNo],0,200,200) = mrYes then Halt;
end;

procedure InitBille;
// Initialiser la bille
begin
     Bille.Bmp := TBitmap.Create;
     with Bille.Bmp do
     begin
          Transparent := True;
          Width := rayon * 2;
          Height := rayon * 2;
          PixelFormat := pf24bit;
          LoadFromResourceName(HInstance,'Bille');
     end;
     Bille.Place := TBitmap.Create;
     with Bille.Place do
     begin
          Width := rayon * 2;
          Height := rayon * 2;
          PixelFormat := pf24bit;
     end;
     with Bille.rect do
     begin
          Left := 0;
          Top := 0;
          Right := rayon * 2;
          Bottom := rayon * 2;
     end;
     with Bille do
     begin
          dep.X := 412;
          dep.Y := 490;
          but := dep;
          va := 1;
          ok := False;
          score := 0;
     end;
end;

procedure InitBGuide;
begin
     BGuide := TBitmap.Create;
     with BGuide do
     begin
          PixelFormat := pf24bit;
          Transparent := True;
          Width := 428;
          Height := 692;
          LoadFromResourceName(HInstance,'Trace');
     end;
end;

procedure InitBlend;
// Initialiser BlendFunc
begin
     nF := 0;
     with BlendFunc do
     begin
          BlendOp := AC_SRC_OVER;     // Src over dest
          BlendFlags := 0;            // Doit être 0
          SourceConstantAlpha := 127; // 50% transparent <=> dest = (Src Dest +) / 2
          AlphaFormat := 0;           // 0 pour nous utilisons SourceConstantAlpha
     end;
     Flipper.AlphaBlend := False;
end;

procedure MontreTete;
begin
     with VAnime do
     begin
          nom := 'Tete';
          pts.X := 185;
          pts.Y := 5;
     end;
     Anime;
end;

procedure InitBFlip;
begin
     BFlip := TBitmap.Create;
     with BFlip do
     begin
          Width := Flipper.Billard.Width;
          Height := Flipper.Billard.Height;
          PixelFormat := pf24bit;
          LoadFromResourceName(HInstance,'Flip');
     end;
     FLipper.Billard.Picture.Assign(BFlip);
     with VAnime do
     begin
          nom := 'Jackpot';
          pts.X := 2;
          pts.Y := 258;
     end;
     Anime;
     MontreTete;
end;

end.
