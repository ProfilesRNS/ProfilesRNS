using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Sockets;
using System.Net;
using System.Configuration;
using Profiles.Framework.Utilities;

namespace Profiles.ORNG.Utilities
{
    public class SocketConnectionPool
    {
        private int POOL_MAX_SIZE;
        private int POOL_MIN_SIZE;
        private int EXPIRE_SECONDS;
        private int RECIEVE_TIMEOUT;
        private string server;
        private int port;
        private Queue<CustomSocket> availableSockets = null;
        private bool Initialized = false;
        private int SocketCounter = 0;

        public SocketConnectionPool(string server, int port, int minConnections, int maxConnections, int expire, int timeout)
        {
            this.POOL_MAX_SIZE = maxConnections;
            this.POOL_MIN_SIZE = minConnections;
            this.EXPIRE_SECONDS = expire;
            this.RECIEVE_TIMEOUT = timeout;
            this.server = server;
            this.port = port;
            this.availableSockets = new Queue<CustomSocket>();
            for (int i = 0; i < minConnections; i++)
            {
                CustomSocket cachedSocket = ConnectSocket();
                PutSocket(cachedSocket);
            }

            Initialized = true;

            DebugLogging.Log("Connection Pool is initialized" +
                   " with Max Number of " +
                   POOL_MAX_SIZE.ToString() + " And Min number of " +
                   availableSockets.Count.ToString());
        }

        public void PutSocket(CustomSocket socket)
        {
            DebugLogging.Log("Put Socket -> Pool size: " + availableSockets.Count.ToString());
            lock (availableSockets)
            {
                TimeSpan socketLifeTime = DateTime.Now.Subtract(socket.TimeCreated);
                if (availableSockets.Count < POOL_MAX_SIZE && socketLifeTime.Seconds < EXPIRE_SECONDS)
                {
                    if (socket != null)
                    {
                        if (socket.Connected)
                        {
                            availableSockets.Enqueue(socket);

                            DebugLogging.Log("Socket Queued -> Pool size: " + availableSockets.Count.ToString());
                        }
                        else
                        {
                            socket.Close();
                        }
                    }
                }
                else
                {
                    socket.Close();
                    DebugLogging.Log("PutSocket - Socket is forced " +
                                       "to closed -> Pool size: " +
                                       availableSockets.Count.ToString());
                }
            }
        }

        public CustomSocket GetSocket()
        {
            DebugLogging.Log("Get Socket -> Pool size: " + availableSockets.Count.ToString());
            if (availableSockets.Count > 0)
            {
                lock (availableSockets)
                {
                    CustomSocket socket = null;
                    while (availableSockets.Count > 0)
                    {
                        socket = availableSockets.Dequeue();

                        if (socket.Connected)
                        {
                            DebugLogging.Log("Socket Dequeued -> Pool size: " +
                                               availableSockets.Count.ToString());

                            return socket;
                        }
                        else
                        {
                            socket.Close();
                            System.Threading.Interlocked.Decrement(ref SocketCounter);
                            DebugLogging.Log("GetSocket -- Close -- Count: " +
                                                               SocketCounter.ToString());
                        }
                    }
                }
            }
            return ConnectSocket();
        }

        private CustomSocket ConnectSocket()
        {
            CustomSocket s = null;
            IPHostEntry hostEntry = null;

            // Get host related information.
            hostEntry = Dns.GetHostEntry(server);

            // Loop through the AddressList to obtain the supported AddressFamily. This is to avoid
            // an exception that occurs when the host IP Address is not compatible with the address family
            // (typical in the IPv6 case).
            foreach (IPAddress address in hostEntry.AddressList)
            {
                IPEndPoint ipe = new IPEndPoint(address, port);
                CustomSocket tempSocket =
                    new CustomSocket(ipe.AddressFamily, SocketType.Stream, ProtocolType.Tcp);

                try
                {
                    tempSocket.Connect(ipe);
                }
                catch
                {
                    // ignore error, move on to the next entry
                }

                if (tempSocket.Connected)
                {
                    s = tempSocket;
                    s.ReceiveTimeout = RECIEVE_TIMEOUT;
                    break;
                }
                else
                {
                    continue;
                }
            }
            return s;
        }
    
    }

    public class CustomSocket : Socket
    {
        private DateTime _TimeCreated;

        public DateTime TimeCreated
        {
            get { return _TimeCreated; }
            set { _TimeCreated = value; }
        }

        public CustomSocket(AddressFamily af, SocketType st, ProtocolType pt)
            : base(af, st, pt)
        {
            _TimeCreated = DateTime.Now;
        }
    }
}