/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using System.Data;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using System.Text;

namespace Profiles.Profile.Modules.NetworkTimeline
{
	public partial class NetworkTimeline : BaseModule
	{
		public NetworkTimeline() : base()
		{ }

		public NetworkTimeline(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
			: base(pagedata, moduleparams, namespaces)
        {}
        
		protected void Page_Load(object sender, EventArgs e)
		{
			InfoCaption = base.GetModuleParamString("InfoCaption")
				.Replace("@SubjectName",				
						this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName", this.Namespaces).InnerText + " " +
						this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName", this.Namespaces).InnerText
				);
			DrawProfilesModule();	
		}
		
		 public void DrawProfilesModule()
		 {

			 // Get subject node id
			 Int64 qsNodeId;
			 if (Int64.TryParse(HttpContext.Current.Request.QueryString["subject"].ToString(), out qsNodeId)==false)				 
				 throw new InvalidOperationException(String.Format("Expected Int64 NodeId, '{0}' was returned.", HttpContext.Current.Request.QueryString["subject"].ToString()));

			// Get stored proc based on timeline type
			string timelineType = base.GetModuleParamString("TimelineType");
			string proc = null;
			switch (timelineType)
			{
				case "CoAuthor":
					proc = "[Profile.Module].[NetworkTimeline.Person.CoAuthorOf.GetData]";
					break;
				case "Concept":
					proc = "[Profile.Module].[NetworkTimeline.Person.HasResearchArea.GetData]";
					break;
				default:
					throw new InvalidOperationException("Please select ChartType.");
			}
			
			// Get data
			Profiles.Profile.Utilities.DataIO dataIO = new Profiles.Profile.Utilities.DataIO();
			DataView dataView = dataIO.GetNetworkTimeline(new RDFTriple(qsNodeId), proc);
		 
			// Draw timeline chart
			if (dataView.Count >=0)
			{
				int x=0, y=0, i, a, b, j, c, d, n, w, k=0;
				bool drawAvg;
				string label = null;
				
				if (int.TryParse(dataView[0]["a"].ToString(), out a)==false)
					throw new InvalidOperationException("Value 'a' is not a number");
								
				if (int.TryParse(dataView[0]["b"].ToString(), out b)==false)
					throw new InvalidOperationException("Value 'b' is not a number");

				if (int.TryParse(dataView[0]["n"].ToString(), out n)==false)
					throw new InvalidOperationException("Value 'n' is not a number");				
					
				j = b - a;
				c = Convert.ToInt32(j/2 + 0.5);
				d = Convert.ToInt32(j/15) + 1;
				w = 400;
				
				SolidBrush brushWhite = new SolidBrush(Color.White);
				SolidBrush brushAvg = new SolidBrush(Color.FromArgb(204,0,30));
				SolidBrush brushPub = new SolidBrush(Color.Blue);
				
				Pen penTimeline = new Pen(Color.FromArgb(170,170,204), 2);
				Pen penTimelineThin = new Pen(Color.FromArgb(230,230,230), 1);
				Pen penYears = new Pen(Color.FromArgb(102,102,102), 1);
				Pen penGraphBox = new Pen(Color.FromArgb(102,102,102), 1);
				
				Bitmap bitmap = new Bitmap(w + 30, n*20 + 40);
				
				Graphics graphic = Graphics.FromImage(bitmap);
				graphic.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.Half;
				
				// Draw background white
				graphic.FillRectangle(brushWhite, 0, 0, w + 30, n*20 + 40);
				
				// Draw year key at top
				graphic.DrawLine(penYears, new Point(15, 20), new Point(15+w, 20));
				for (i = 0; i<=j; i++)
				{
					x = 15+ Convert.ToInt32((w*i/j));
					graphic.DrawLine(penYears, new Point(x, 15), new Point(x, 20));
					if ((j-i) % d == 0)
						graphic.DrawString(
							(a + i).ToString(), 
							new Font("Arial", 7), 
							new SolidBrush(Color.Black), 
							new Point(x-10, 0)
						);
				
				}
				
				// Draw timelines
				for (i = 0; i <= dataView.Count -1; i++)
				{
					if (label != dataView[i]["label"].ToString()) 
						k++;
					
					x = Convert.ToInt32(Convert.ToSingle(dataView[i]["x"]) * w + 0.5) + 15;
					y = k * 20 + 20;
					
					if (label != dataView[i]["label"].ToString()) 
					{
						
						label = dataView[i]["label"].ToString();
						//oGraphic.DrawString(sLabel, New Font("Arial", 7), New SolidBrush(Color.Black), New Point(10, y))
						graphic.DrawLine(penTimelineThin, new PointF(15, y), new PointF(15+w, y));
						graphic.DrawLine(penTimeline, new PointF(15 + (Convert.ToSingle(dataView[i]["MinX"])) * w, y), new PointF(15 + (Convert.ToSingle(dataView[i]["MaxX"])) * w, y));
					}
					graphic.FillRectangle(brushPub, x-1, y-3, 3, 6);
					drawAvg = false;
					if (i == dataView.Count - 1)
					{
						drawAvg = true;
					}
					else if (label != dataView[i+1]["label"].ToString()) 
					{
						drawAvg = true;
					}
					
					if (drawAvg) 
					{
						x = Convert.ToInt32(Convert.ToSingle(dataView[i]["AvgX"]) * w + 0.5) + 15;
						graphic.FillEllipse(brushAvg, new Rectangle(x-5,y-5,10,10));
					}
				}
				
				graphic.DrawLine(penGraphBox, new Point(15, 20), new Point(15, 30 + 20*n));
				
				// Write out image
				byte[] imageArray;
				using (System.IO.MemoryStream imageStream = new System.IO.MemoryStream())
				{
					bitmap.Save(imageStream, ImageFormat.Png);
					imageArray = new byte[imageStream.Length];
					imageStream.Seek(0, System.IO.SeekOrigin.Begin);
					imageStream.Read(imageArray, 0, Convert.ToInt32(imageStream.Length));

					
				}
				timelineImage.Src = "data:image/png;base64," + Convert.ToBase64String(imageArray);
				
				// Write out timeline detail list
				StringBuilder sb = new StringBuilder();				
				label = string.Empty;
				for (i = 0; i <= dataView.Count -1; i++)
				{					
					if (label != dataView[i]["label"].ToString())
					{
						sb.AppendFormat("<a href=\"{0}\">{1}</a><br/>", dataView[i]["ObjectURI"].ToString(), dataView[i]["label"].ToString());
						label = dataView[i]["label"].ToString();
					}					
				}
				timelineDetails.InnerHtml = sb.ToString();
			}
		 }

		 public string InfoCaption { get; set; }
	}
}