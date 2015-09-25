unit PusherClient;

interface

uses
  SysUtils,
  ComObj,
  System.Generics.Collections;

type
  TCallbackProcedure = reference to procedure(message: string);
  TEventCallback = TDictionary<string, TCallbackProcedure>;
  TSubscribeList = TObjectDictionary<string, TEventCallback>;
  TConnectionOptions = set of (coUseSSL);

  TPusherClient = class
  strict private
    class var FInstance : TPusherClient;
  private
    FOnLog: TCallbackProcedure;
    FOnError: TCallbackProcedure;
    FOnConnectionStateChange: TCallbackProcedure;
    FSubscribed: TSubscribeList;
    PusherClientNative: OleVariant;
    class procedure ReleaseInstance();
    constructor Create;
    procedure Error(Message: string);
    procedure Log(Message: string);
    procedure ConnectionStateChange(Message: string);
  public
    class function GetInstance(): TPusherClient;
    procedure Connect(Key: string; Options: TConnectionOptions = [coUseSSL];
      CustomHost: string = '');
    procedure Disconnect();
    procedure Subscribe(Channel, EventName: String; Callback: TCallbackProcedure);
    property OnError: TCallbackProcedure read FOnError write FOnError;
    property OnLog: TCallbackProcedure read FOnLog write FOnLog;
    property OnConnectionStateChange: TCallbackProcedure read FOnConnectionStateChange
      write FOnConnectionStateChange;
    destructor Destroy; override;
  end;


implementation

{ TPusherClient }

procedure OnLogStdCall(Message: pchar); stdcall;
begin
  TPusherClient.GetInstance.Log(StrPas(Message));
end;

procedure OnErrorStdCall(message: pchar); stdcall;
begin
  TPusherClient.GetInstance.Error(StrPas(Message));
end;

procedure OnSubscribeEventStdCall(Channel: pchar; EventName: pchar; Message: pchar); stdcall;
var
  ErrorMessage: string;
begin
  try
    TPusherClient.GetInstance.FSubscribed[StrPas(Channel)][StrPas(EventName)](StrPas(Message));
  except
    on E:Exception do
    begin
      ErrorMessage := Format(
        'A Subscribed Event Message has been received but can''t be delivered.'
        + sLineBreak + '[Channel][Event]: Message: [%s][%s]: [%s]'
        + sLineBreak + 'Error: [%s]',
        [StrPas(Channel), StrPas(EventName), StrPas(Message), E.Message]);
      TPusherClient.GetInstance.Error(ErrorMessage);
      TPusherClient.GetInstance.Log(ErrorMessage);
    end;
  end;
end;

procedure OnConnectionStateChangeStdCall(message: pchar); stdcall;
begin
  TPusherClient.GetInstance.ConnectionStateChange(StrPas(Message));
end;

procedure TPusherClient.Connect(Key: string; Options: TConnectionOptions; CustomHost: string);
begin
  PusherClientNative.InitializePusherClient(Key, coUseSSL in Options, CustomHost);

  PusherClientNative.RegisterOnErrorCallback(LongInt(@OnErrorStdCall));
  PusherClientNative.RegisterLogCallback(LongInt(@OnLogStdCall));
  PusherClientNative.RegisterOnConnectionStateChangeCallback(LongInt(@OnConnectionStateChangeStdCall));
  PusherClientNative.RegisteronSubscribedEventMessageCallback(LongInt(@OnSubscribeEventStdCall));

  PusherClientNative.Connect;
end;

constructor TPusherClient.Create;
begin
  FSubscribed := TSubscribeList.Create([doOwnsValues]);

  PusherClientNative := CreateOleObject('PusherClientNative.Pusher');
end;

destructor TPusherClient.Destroy;
begin
  PusherClientNative := varNull;
  FSubscribed.Free;
  inherited;
end;

procedure TPusherClient.Disconnect;
begin
  PusherClientNative.Disconnect;
end;

class function TPusherClient.GetInstance: TPusherClient;
begin
  if not Assigned(Self.FInstance) then
    self.FInstance := TPusherClient.Create;
  Result := Self.FInstance;
end;

procedure TPusherClient.ConnectionStateChange(Message: string);
begin
  if Assigned(TPusherClient.GetInstance.FOnConnectionStateChange) then
    TPusherClient.GetInstance.FOnConnectionStateChange(Message);
end;

procedure TPusherClient.Error(Message: string);
begin
  if Assigned(TPusherClient.GetInstance.FOnError) then
    TPusherClient.GetInstance.FOnError(Message);
end;

procedure TPusherClient.Log(Message: string);
begin
  if Assigned(TPusherClient.GetInstance.FOnLog) then
    TPusherClient.GetInstance.FOnLog(Message);
end;

class procedure TPusherClient.ReleaseInstance;
begin
  if Assigned(Self.FInstance) then
    Self.FInstance.Free;
end;

procedure TPusherClient.Subscribe(Channel, EventName: String;
  Callback: TCallbackProcedure);
var
  EventCallback: TEventCallback;
begin
  if FSubscribed.ContainsKey(Channel) then
    EventCallback := FSubscribed[Channel]
  else
  begin
    EventCallback := TEventCallback.Create;
    FSubscribed.Add(Channel, EventCallback);
  end;

  if EventCallback.ContainsKey(EventName) then
    EventCallback[EventName] := Callback
  else
  begin
    EventCallback.Add(EventName, Callback);
    PusherClientNative.Subscribe(Channel, EventName);
  end;
end;

initialization
finalization
  TPusherClient.ReleaseInstance();

end.
