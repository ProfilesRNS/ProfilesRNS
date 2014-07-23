using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class IOHelper
    {
        public static void CopyDirectory(DirectoryInfo source, DirectoryInfo destination)
        {
            if (!destination.Exists)
            {
                destination.Create();
            }

            // Copy all files.
            FileInfo[] files = source.GetFiles();
            foreach (FileInfo file in files)
            {
                if (!file.FullName.EndsWith(".scc"))
                {
                    file.CopyTo(Path.Combine(destination.FullName, file.Name), true);
                }
            }

            // Process subdirectories.
            DirectoryInfo[] dirs = source.GetDirectories();
            foreach (DirectoryInfo dir in dirs)
            {
                // Get destination directory.
                string destinationDir = Path.Combine(destination.FullName, dir.Name);

                // Call CopyDirectory() recursively.
                CopyDirectory(dir, new DirectoryInfo(destinationDir));
            }
        }

        public static void CopyDirectory(string source, string destination)
        {
            CopyDirectory(new DirectoryInfo(source), new DirectoryInfo(destination));
        }

        // This method will allow you to copy a file as a particular network user.
        public static void CopyDirectory(string sourcePath, string destinationPath, string username, string password)
        {
            System.IO.DirectoryInfo source = new System.IO.DirectoryInfo(sourcePath);
            DevelopmentBase.Utilities.SecurityClass.RunAs(delegate() { CopyDirectory(source, new System.IO.DirectoryInfo(destinationPath)); }, username, password);
        }

        public static void DeleteContents(DirectoryInfo source)
        {
            FileInfo[] files = source.GetFiles();
            foreach (FileInfo file in files)
            {
                file.Attributes = FileAttributes.Normal;
                file.Delete();
            }

            // Process subdirectories.
            DirectoryInfo[] dirs = source.GetDirectories();
            foreach (DirectoryInfo dir in dirs)
            {
                DeleteDirectory(dir.FullName);
            }
        }

        public static void DeleteContents(string source)
        {
            DeleteContents(new DirectoryInfo(source));
        }

        private static bool MoveAndOverWrite(string sSource, string sDestn)
        {

            try
            {
                if (File.Exists(sSource) == true)
                {
                    if (File.Exists(sDestn) == true)
                    {
                        File.Copy(sSource, sDestn, true);
                        File.Delete(sSource);
                        return true;
                    }
                    else
                    {
                        File.Move(sSource, sDestn);
                        return true;
                    }
                }
                else
                {
                    Console.WriteLine("Specifed file does not exist");
                    return false;
                }
            }
            catch (FileNotFoundException exFile)
            {
                Console.WriteLine("File Not Found " + exFile.Message);
                return false;
            }
            catch (DirectoryNotFoundException exDir)
            {
                Console.WriteLine("Directory Not Found " + exDir.Message);
                return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return false;
            }
        }

        public static bool DeleteDirectory(string Path)
        {
            if (Directory.Exists(Path))
            {
                try
                {
                    ClearAttributes(Path);
                    Directory.Delete(Path, true);
                }
                catch (IOException e)
                {
                    Console.WriteLine(e.Message);
                    return false;
                }
            }
            return true;
        }

        public static void ClearAttributes(string currentDir)
        {
            if (Directory.Exists(currentDir))
            {
                string[] subDirs = Directory.GetDirectories(currentDir);
                foreach (string dir in subDirs)
                    ClearAttributes(dir);
                string[] files = files = Directory.GetFiles(currentDir);
                foreach (string file in files)
                    File.SetAttributes(file, FileAttributes.Normal);
            }
        }

        public static void CopyStream(Stream input, Stream output)
        {
            byte[] buffer = new byte[8 * 1024];
            int len;
            while ( (len = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                output.Write(buffer, 0, len);
            }    
        }

        public static void WriteStreamToFile(Stream input, string filename, bool deleteIfExists)
        {
            if (!deleteIfExists)
            {
                if (System.IO.File.Exists(filename))
                {
                    System.IO.File.Delete(filename);
                }
            }
            if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(filename)))
            {
                System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(filename));
            }
            using (Stream file = File.OpenWrite(filename))
            {
                CopyStream(input, file);
            }
        }
    }
}
