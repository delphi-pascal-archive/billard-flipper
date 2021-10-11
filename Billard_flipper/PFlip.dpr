program PFlip;

uses
  Forms,
  UAnime in 'UAnime.pas',
  APropos in 'APropos.pas' {FPropos},
  UFlip in 'UFlip.pas' {Flipper},
  Utile in 'Utile.pas',
  UAvance in 'UAvance.pas',
  UAnimeThread in 'UAnimeThread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFlipper, Flipper);
  Application.Run;
end.
