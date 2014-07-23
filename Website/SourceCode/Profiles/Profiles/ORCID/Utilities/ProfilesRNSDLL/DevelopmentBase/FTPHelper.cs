using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class FTPFileDownloader
    {
        //Connects to the FTP server and request the list of available files
        public List<string> getFileList(string FTPAddress, string username, string password)
        {
            List<string> files = new List<string>();

            //Create FTP request
            FtpWebRequest request = FtpWebRequest.Create(FTPAddress) as FtpWebRequest;

            request.Method = WebRequestMethods.Ftp.ListDirectory;
            request.Credentials = new NetworkCredential(username, password);
            request.UsePassive = true;
            request.UseBinary = true;
            request.KeepAlive = false;

            FtpWebResponse response = request.GetResponse() as FtpWebResponse;
            using (Stream responseStream = response.GetResponseStream())
            {
                using (StreamReader reader = new StreamReader(responseStream))
                {
                    while (!reader.EndOfStream)
                    {
                        files.Add(reader.ReadLine());
                    }
                }
            }
            return files;
        }

        public void downloadFile(string FTPAddress, string filename, string username, string password, string destFile)
        {
            FtpWebRequest request = FtpWebRequest.Create(FTPAddress + filename) as FtpWebRequest;
            request.Method = WebRequestMethods.Ftp.DownloadFile;
            request.Credentials = new NetworkCredential(username, password);
            request.UsePassive = true;
            request.UseBinary = true;
            request.KeepAlive = false; //close the connection when done
            //Streams
            FtpWebResponse response = request.GetResponse() as FtpWebResponse;
            Stream reader = response.GetResponseStream();

            byte[] buffer = new byte[1024];
            using (Stream streamFile = File.Create(destFile))
            {
                while (true)
                {
                    int bytesRead = reader.Read(buffer, 0, buffer.Length);
                    if (bytesRead == 0)
                    {
                        break;
                    }
                    else
                    {
                        streamFile.Write(buffer, 0, bytesRead);
                    }
                }
            }
        }
    }
}



