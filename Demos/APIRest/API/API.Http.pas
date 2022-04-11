(*

  Trysil
  Copyright � David Lastrucci
  All rights reserved

  Trysil - Operation ORM (World War II)
  http://codenames.info/operation/orm/

*)
unit API.Http;

interface

uses
  System.Classes,
  System.SysUtils,
  Trysil.Data.FireDAC.SqlServer,
  Trysil.JSon.Events,
  Trysil.Http,

  API.Config,
  API.Context,
  API.Controller.Company,
  API.Controller.Employee;

type

{ TAPIHttp }

  TAPIHttp = class
  strict private
    FServer: TTHttpServer<TAPIContext>;

    procedure RegisterLogWriter;
    procedure RegisterAuthentication;
    procedure RegisterControllers;

    function GetPort: Word;
    function GetStarted: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AfterConstruction; override;

    procedure Start;
    procedure Stop;

    property Port: Word read GetPort;
    property Started: Boolean read GetStarted;
  end;

implementation

{ TAPIHttp }

constructor TAPIHttp.Create;
begin
  inherited Create;
  FServer := TTHttpServer<TAPIContext>.Create;
end;

destructor TAPIHttp.Destroy;
begin
  FServer.Free;
  inherited Destroy;
end;

procedure TAPIHttp.AfterConstruction;
begin
  inherited AfterConstruction;
  FServer.Port := TAPIConfig.Instance.Server.Port;

  FServer.CorsConfig.AllowHeaders := TAPIConfig.Instance.Cors.AllowHeaders;
  FServer.CorsConfig.AllowOrigin := TAPIConfig.Instance.Cors.AllowOrigin;

  TTSqlServerConnection.RegisterConnection(
    TAPIConfig.Instance.Database.ConnectionName,
    TAPIConfig.Instance.Database.Server,
    TAPIConfig.Instance.Database.Username,
    TAPIConfig.Instance.Database.Password,
    TAPIConfig.Instance.Database.DatabaseName);

  RegisterLogWriter;
  RegisterAuthentication;
  RegisterControllers;
end;

procedure TAPIHttp.RegisterLogWriter;
begin
  // FServer.RegisterLogWriter<...>();
end;

procedure TAPIHttp.RegisterAuthentication;
begin
  // FServer.RegisterAuthentication<...>();
end;

procedure TAPIHttp.RegisterControllers;
begin
  FServer.RegisterController<TAPICompanyController>();
  FServer.RegisterController<TAPIEmployeeController>();
end;

procedure TAPIHttp.Start;
begin
  FServer.Start;
end;

procedure TAPIHttp.Stop;
begin
  FServer.Stop;
end;

function TAPIHttp.GetPort: Word;
begin
  result := FServer.Port;
end;

function TAPIHttp.GetStarted: Boolean;
begin
  result := FServer.Started;
end;

end.

