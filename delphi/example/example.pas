unit example;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ComObj, PusherClient;

type
  TPusherClientExampleForm = class(TForm)
    GroupBox2: TGroupBox;
    EdtKey: TLabeledEdit;
    EdtHost: TLabeledEdit;
    ChkUseSSL: TCheckBox;
    BtnConnect: TButton;
    GroupBox1: TGroupBox;
    EdtChannel: TLabeledEdit;
    EdtEvent: TLabeledEdit;
    BtnSubscribe: TButton;
    SubscribeList: TListBox;
    LblStatus: TLabel;
    GroupBox3: TGroupBox;
    MemoError: TMemo;
    GroupBox4: TGroupBox;
    MemoLog: TMemo;
    procedure BtnSubscribeClick(Sender: TObject);
    procedure BtnConnectClick(Sender: TObject);
  private
    PusherClient: TPusherClient;
    procedure InitializePusherClient;
    procedure ConnectionStatus(Status: string);
    procedure Connect;
    procedure Disconnect;
  public
    { Public declarations }
  end;

var
  PusherClientExampleForm: TPusherClientExampleForm;

implementation

uses
  StrUtils;

Const
  DISCONNECTED = 'Disconnected';
  CONNECTED = 'Connected';

{$R *.dfm}

procedure TPusherClientExampleForm.BtnConnectClick(Sender: TObject);
begin
  InitializePusherClient;

  if LblStatus.Caption = DISCONNECTED then
    Connect
  else
    Disconnect;
end;

procedure TPusherClientExampleForm.BtnSubscribeClick(Sender: TObject);
var
  ListItem: string;
begin
  if ((EdtChannel.Text = '') or (EdtEvent.Text = '')) then
    raise Exception.Create('Channel and Event Name can''t be blank');

  ListItem := EdtChannel.Text + ' | ' + EdtEvent.Text;

  if SubscribeList.Items.IndexOf(ListItem) = -1 then
    SubscribeList.Items.Add(EdtChannel.Text + ' | ' + EdtEvent.Text);

   PusherClient.Subscribe(EdtChannel.Text, EdtEvent.Text,
     procedure (Message: string)
     begin
       MemoLog.Lines.Add('[EVENT-MESSAGE]: ' + Message);
       Application.ProcessMessages;
     end)
end;

procedure TPusherClientExampleForm.Connect;
var
  Options: TConnectionOptions;
begin
  Options := [];
  if ChkUseSSL.Checked then
    Options := [coUseSSL];

  PusherClient.Connect(EdtKey.Text, Options, EdtHost.Text);
end;

procedure TPusherClientExampleForm.ConnectionStatus(Status: string);
begin
  LblStatus.Caption := Status;
  if Status = DISCONNECTED then
    BtnConnect.Caption := 'Connect'
  else
    BtnConnect.Caption := 'Disconnect';
end;

procedure TPusherClientExampleForm.Disconnect;
begin
  PusherClient.Disconnect;
end;

procedure TPusherClientExampleForm.InitializePusherClient;
begin
  PusherClient := TPusherClient.GetInstance;
  PusherClient.OnError := procedure(Message: string)
    begin
      MemoError.Lines.Add('[ERROR]: ' + Message);
      Application.ProcessMessages;
    end;

  PusherClient.OnLog := procedure(Message: string)
    begin
      MemoLog.Lines.Add('[LOG]: ' + Message);
      Application.ProcessMessages;
    end;

  PusherClient.OnConnectionStateChange := procedure(Message: string)
    begin
      ConnectionStatus(Message);
    end;
end;

end.
