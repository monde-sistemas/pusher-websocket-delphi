# Pusher Delphi Client Library

This is a Delphi library for interacting with the Pusher WebSocket API.

Register at http://pusher.com and use the application credentials within your app as shown below.

More general documentation can be found at http://pusher.com/docs/.

This library is based on [Pusher .NET Client](https://github.com/pusher-community/pusher-websocket-dotnet) and uses the .NET lib as a DLL (see dotnet folder), so, this lib depends on .NET 4.5.

Tested on Delphi XE7 but should work in any XE+ version.

Looking for a server library? Take a look at [pusher-http-delphi](https://github.com/monde-sistemas/pusher-http-delphi)

## Limitations

So far this lib only supports public channels. The .net library has support to privates and presence channels, so, the implementation shouldn't be so difficult.  

## Dependencies

* Newtonsoft.Json.dll
* WebSocket4Net.dll
* PusherClient.dll
* PusherClientNative.dll

All of them are shipped with this lib releases.

## Usage

Download the [last release](https://github.com/monde-sistemas/pusher-websocket-delphi/releases/latest) zip package and add it to your project. Make sure all the dependencies are on the same folder that your exe.

Add `PusherClient` to your unit uses clause.

```
PusherClient := TPusherClient.GetInstance;

PusherClient.Connect('your_pusher_key');

PusherClient.Subscribe('some_public_channel', 'some_event',
  procedure (Message: string)
  begin
    Log('[Event-Message]: ' + Message);
  end)
```

Remember to pay attention to the thread context in which you're running this code. The `Log` method implementation look like this (for use with VCL):
```
TThread.Queue(nil, procedure
  begin
    MemoLog.Lines.Add(Message)
  end);
end;
```

### Secure Connections / SSL

SSL is enabled by default. You can disable it by passing a empty option list `[]` to the `Connect` method:
```
PusherClient.Connect('your_pusher_key', []);
```

### Custom Host Address

It is possible to use a custom host address:
```
PusherClient.Connect('your_pusher_key', [], 'localhost');
```
The [default value](https://github.com/pusher-community/pusher-websocket-dotnet/blob/master/PusherClient/Pusher.cs#L43) is `ws.pusherapp.com` which is the pusher.com endpoint, but you can also use it with a [poxa](https://github.com/edgurgel/poxa) server hosted in your own server.

### Events

You can use some events to track the Pusher Client activity.

```
PusherClient.OnError := procedure(Message: string)
  begin
    Error('[ERROR]: ' + Message);
  end;
```
```
PusherClient.OnLog := procedure(Message: string)
  begin
    Log('[LOG]: ' + Message);
  end;
```
```
PusherClient.OnConnectionStateChange := procedure(Message: string)
  begin
    Log('[STATUS]: ' + Message);
  end;
```

### Example

You can take a look at the `PusherClientExample` at `delphi\example` for more details.

## Contributing

This lib is a work in progress and any help is greatly appreciated.

Found a bug? Send us a Pull Request or create an issue, we will do our best to help.

## Acknowledgements

Thanks to [@leggetter](https://github.com/leggetter) for the help on the [pusher-websocket-dotnet](https://github.com/pusher-community/pusher-websocket-dotnet) which is the base of this work.
