using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Word;
using word = Microsoft.Office.Interop.Word;
using Microsoft.Office.Interop.PowerPoint;
using System.IO;

namespace ConvertToPDF
{
    class Program
    {
        static int Main(string[] args)
        {
            try
            {
                string path = Directory.GetCurrentDirectory();
                Console.WriteLine(path);
                path = path.Replace("\\ConvertToPDF\\bin\\Debug", "");
                path = path + "\\";

                word.Application app = new word.Application();
                Document doc = app.Documents.Open(path + "..\\ProfilesRNS_ReadMeFirst.docx");
                if (doc != null)

                {
                    doc.SaveAs2(path + "ProfilesRNS\\ProfilesRNS_ReadMeFirst.pdf", word.WdSaveFormat.wdFormatPDF);
                    doc.Close();

                    doc = app.Documents.Open(path + "..\\Documentation\\ProfilesRNS_ArchitectureGuide.docx");
                    doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ProfilesRNS_ArchitectureGuide.pdf", word.WdSaveFormat.wdFormatPDF);
                    doc.Close();

                    doc = app.Documents.Open(path + "..\\Documentation\\ProfilesRNS_InstallGuide.docx");
                    doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ProfilesRNS_InstallGuide.pdf", word.WdSaveFormat.wdFormatPDF);
                    doc.Close();

                    doc = app.Documents.Open(path + "..\\Documentation\\ProfilesRNS_APIGuide.doc");
                    doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ProfilesRNS_APIGuide.pdf", word.WdSaveFormat.wdFormatPDF);
                    doc.Close();

                    doc = app.Documents.Open(path + "..\\Documentation\\ProfilesRNS_ReleaseNotes.docx");
                    doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ProfilesRNS_ReleaseNotes.pdf", word.WdSaveFormat.wdFormatPDF);
                    doc.Close();

                    doc = app.Documents.Open(path + "..\\Documentation\\ProfilesRNS_v2.x.x_UpgradeGuide.docx");
                    doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ProfilesRNS_v2.x.x_UpgradeGuide.pdf", word.WdSaveFormat.wdFormatPDF);
                    doc.Close();
                    /*
                                        doc = app.Documents.Open(path + "..\\Documentation\\ORNG\\ORNG_GadgetDevelopment.docx");
                                        doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ORNG\\ORNG_GadgetDevelopment.pdf", word.WdSaveFormat.wdFormatPDF);
                                        doc.Close();

                                        doc = app.Documents.Open(path + "..\\Documentation\\ORNG\\ORNG_InstallationGuide.docx");
                                        doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ORNG\\ORNG_InstallationGuide.pdf", word.WdSaveFormat.wdFormatPDF);
                                        doc.Close();

                                        doc = app.Documents.Open(path + "..\\Documentation\\ORNG\\ORNG_TroubleShootingGuide.docx");
                                        doc.SaveAs2(path + "ProfilesRNS\\Documentation\\ORNG\\ORNG_TroubleShootingGuide.pdf", word.WdSaveFormat.wdFormatPDF);
                                        doc.Close();
                    */
                    app.Quit();


                    Microsoft.Office.Interop.PowerPoint.Application pptApp = new Microsoft.Office.Interop.PowerPoint.Application();

                    Microsoft.Office.Interop.PowerPoint.Presentation presentation = pptApp.Presentations.Open(path + "..\\Documentation\\ProfilesRNS_DataFlowDiagram.pptx");
                    presentation.SaveAs(path + "ProfilesRNS\\Documentation\\ProfilesRNS_DataFlowDiagram.pdf", Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType.ppSaveAsPDF);
                    presentation.Close();


                    presentation = pptApp.Presentations.Open(path + "..\\Documentation\\ProfilesRNS_OntologyDiagram.pptx");
                    presentation.SaveAs(path + "ProfilesRNS\\Documentation\\ProfilesRNS_OntologyDiagram.pdf", Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType.ppSaveAsPDF);
                    presentation.Close();
/*
                    presentation = pptApp.Presentations.Open(path + "..\\Documentation\\ORNG\\ORNGArchitecturalDiagram.pptx");
                    presentation.SaveAs(path + "ProfilesRNS\\Documentation\\ORNG\\ORNGArchitecturalDiagram.pdf", Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType.ppSaveAsPDF);
                    presentation.Close();
*/
                    pptApp.Quit();
                }
                else
                {
                    app.Quit();
                    return 2;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine(e.StackTrace);
                return 1;
            }
            return 0;
        }
    }
}
