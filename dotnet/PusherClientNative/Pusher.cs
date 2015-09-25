using System;
using PusherClient;
using System.Runtime.InteropServices;

namespace PusherClientNative
{

    public delegate void NativeCallback([MarshalAs(UnmanagedType.LPWStr)] string text);
    public delegate void NativeSubscribeCallback([MarshalAs(UnmanagedType.LPWStr)] string channel,
        [MarshalAs(UnmanagedType.LPWStr)] string eventName, [MarshalAs(UnmanagedType.LPWStr)] string message);


    [ClassInterface(ClassInterfaceType.None)]
    [ComVisible(true), GuidAttribute("02A3A74A-323F-4AC8-A8E3-3541572B45F3")]
    public class Pusher
    {
        static PusherClient.Pusher pusherClient = null;
        static NativeCallback onLog = null;
        static NativeCallback onError = null;
        static NativeCallback onConnectionStateChange = null;
        static NativeSubscribeCallback onSubscribedEventMessage = null;

        public unsafe void RegisterOnErrorCallback(Int32 callbackPointer)
        {
            onError = GetNativeCallback(callbackPointer);
        }

        public unsafe void RegisterLogCallback(Int32 callbackPointer)
        {
            onLog = GetNativeCallback(callbackPointer);
        }

        public unsafe void RegisteronSubscribedEventMessageCallback(Int32 callbackPointer)
        {
            var callback = new IntPtr(callbackPointer);
            onSubscribedEventMessage = (NativeSubscribeCallback)Marshal.GetDelegateForFunctionPointer(callback, typeof(NativeSubscribeCallback));
        }

        public unsafe void RegisterOnConnectionStateChangeCallback(Int32 callbackPointer)
        {
            onConnectionStateChange = GetNativeCallback(callbackPointer);
        }

        public unsafe void Connect()
        {
            pusherClient.Connect();
        }

        public unsafe void Disconnect()
        {
            pusherClient.Disconnect();
        }

        public void Subscribe(string channel, string eventName)
        {
            CheckInitialization("Subscribe");

            PusherClient.Channel chatChannel = pusherClient.Subscribe(channel);
            chatChannel.Bind(eventName, (dynamic data) =>
             {
                 var message = Convert.ToString(data);
                 Log($"[{channel}][{eventName}]: {message}");

                 if (onSubscribedEventMessage != null)
                     onSubscribedEventMessage(channel, eventName, message);
             });
        }

        private NativeCallback GetNativeCallback(Int32 callbackPointer)
        {
            var callback = new IntPtr(callbackPointer);
            return (NativeCallback)Marshal.GetDelegateForFunctionPointer(callback, typeof(NativeCallback));
        }

        public void InitializePusherClient(string key, bool useSSL = false, string customHost = null)
        {
            Log($"Initializing PusherClient with key = {key}, useSSL = {useSSL}, customHost = {customHost}");
            pusherClient = new PusherClient.Pusher(key, new PusherOptions() { Encrypted = useSSL });
            if ((customHost != null) && (customHost != ""))
                pusherClient.Host = customHost;

            pusherClient.Error += PusherClientError;
            pusherClient.ConnectionStateChanged += PusherClientConnectionStateChanged;
        }

        private void CheckInitialization(string methodName)
        {
            if (pusherClient == null)
            {
                var errorMessage = $"You must call InitializePusherClient(key, useSSL, customHost) before {methodName}";
                Log($"Error: {errorMessage}");
                throw new PusherNativeException(errorMessage);
            }
        }

        private void Log(string message)
        {
            if (onLog != null)
                onLog(message);
        }

        private void Error(string message)
        {
            if (onError != null)
                onError(message);
            Log(message);
        }

        private void ConnectionStateChanged(string message)
        {
            if (onConnectionStateChange != null)
                onConnectionStateChange(message);
        }

        private void PusherClientError(object sender, PusherException error)
        {
            var message = $"PusherClient Error: {error.ToString()}";
            Error(message);
        }

        private void PusherClientConnectionStateChanged(object sender, ConnectionState state)
        {
            Log($"Connection state changed: {state.ToString()}");
            ConnectionStateChanged(state.ToString());
        }
    }
}
