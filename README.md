# Pusher Delphi Client Library

This is a Delphi library for interacting with the Pusher WebSocket API.

Register at http://pusher.com and use the application credentials within your app as shown below.

More general documentation can be found at http://pusher.com/docs/.

This library is based on [Pusher .NET Client](Pusher .NET Client library) and uses the .NET lib as a DLL (see dotnet folder), so, this lib depends on .NET 4.5.

## Limitations

So far this lib only supports public channels. The .net library has support to privates and presence channels, so, the implementation shouldn't be so difficult.  

## Dependencies

* Newtonsoft.Json.dll
* WebSocket4Net.dll
* PusherClient.dll
* PusherClientNative.dll

All of them are shipped with this lib releases.

## Usage

Adds `PusherClient` to your uses clause.

```
PusherClient := TPusherClient.GetInstance;

PusherClient.Connect('your_pusher_key');

PusherClient.Subscribe('some_public_channel', 'some_event',
  procedure (Message: string)
  begin
   Form.Memo.Lines.Add('[Event-Message]: ' + Message);
  end)
```
Make sure all the dependencies are on the same folder that your exe.

### Secure Connections / SSL

You can use SSL by passing the `coUseSSL` connection option to the `Connect` method:
```
PusherClient.Connect('your_pusher_key', [coUseSSL]]);
```

### Custom Host Address

It is possible to use a custom host address:
```
PusherClient.Connect('your_pusher_key', [], 'localhost');
```
The [default value](https://github.com/pusher-community/pusher-websocket-dotnet/blob/master/PusherClient/Pusher.cs#L43) is `ws.pusherapp.com` which is the pusher.com endpoint, but you can also use it wih a [poxa](https://github.com/edgurgel/poxa) server hosted in you own server.

### Events

You can use some events to track the Pusher Client activity.

```
PusherClient.OnError := procedure(Message: string)
  begin
    MemoError.Lines.Add('[ERROR]: ' + Message);
    Application.ProcessMessages;
  end;
```
```
PusherClient.OnLog := procedure(Message: string)
  begin
    MemoLog.Lines.Add('[LOG]: ' + Message);
    Application.ProcessMessages;
  end;
```
```
PusherClient.OnConnectionStateChange := procedure(Message: string)
  begin
    MemoStatus.Lines.Add('[STATUS]: ' + Message);
    Application.ProcessMessages;
  end;
```

### Example

You can take a look at the `PusherClientExample` at `delphi\example` for more details.

## Contributing

This lib is a work in progress and any help is greatly appreciated.

Found a bug? Send us a Pull Request or create an issue, we will do our best to help.

## Acknowledgements

Thanks to [@leggetter](https://github.com/leggetter) for the help on the [pusher-websocket-dotnet](https://github.com/pusher-community/pusher-websocket-dotnet) which is the base of this work.
