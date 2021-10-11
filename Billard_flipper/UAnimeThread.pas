unit UAnimeThread;

interface

uses Windows, Classes, SysUtils;

type
    TAnimeThread = class(TThread)
    private
           procedure Commande;
    public
          constructor Create(CreateSuspended : Boolean);
          destructor Destroy; override;
    protected
          procedure Execute; override;
end;

implementation

uses Utile, UAnime;

constructor TAnimeThread.Create(CreateSuspended : Boolean);
begin
     inherited Create(CreateSuspended);
     FreeOnTerminate := False;
     Priority := tpHigher;
end;

destructor TAnimeThread.Destroy;
begin
     inherited;
end;

procedure TAnimeThread.Commande;
begin
     if Am then Animation;
end;

procedure TAnimeThread.Execute;
begin
     repeat
           Sleep(10);
           Synchronize(Commande);
     until Terminated;
end;

end.
