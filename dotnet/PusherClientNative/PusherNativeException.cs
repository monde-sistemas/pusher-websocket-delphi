using System;

namespace PusherClientNative
{
    [Serializable]
    class PusherNativeException : Exception
    {
        public PusherNativeException(string message): base(message) { }
    }
}
