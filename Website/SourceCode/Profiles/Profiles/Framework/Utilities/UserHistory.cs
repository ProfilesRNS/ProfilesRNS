using System;
using System.Collections.Generic;
using System.Web;

namespace Profiles.Framework.Utilities
{
    public class HistoryItem
    {
        public HistoryItem(string itemlabel, string uri, List<string> types)
        {
            this.ItemLabel = itemlabel;
            this.URI = uri;
            this.Types = types;
            this.TimeStamp = DateTime.Now;
        }
        public string ItemLabel { get; set; }
        public string URI { get; set; }
        public List<string> Types { get; set; }
        public DateTime TimeStamp { get; private set; }

    }

    public class UserHistory
    {
        public void LoadItem(HistoryItem historyitem)
        {

            List<HistoryItem> hi;

            if (HttpContext.Current.Session["HistoryList"] == null)
            {
                hi = new List<HistoryItem>();
                HttpContext.Current.Session["HistoryList"] = hi;
            }

            hi = (List<HistoryItem>)HttpContext.Current.Session["HistoryList"];

            if (hi.Exists(delegate(HistoryItem hiexists) { return hiexists.URI == historyitem.URI; }) == true)
            {
                HistoryItem hiremove;
                hiremove = hi.Find(delegate(HistoryItem hiremoveitem) { return hiremoveitem.URI == historyitem.URI; });
                hi.Remove(hiremove);
            }

            hi.Add(historyitem);
            HttpContext.Current.Session["HistoryList"] = hi;
        }

        public List<HistoryItem> GetItems(int count)
        {
            List<HistoryItem> hi = null;

            if (HttpContext.Current.Session["HistoryList"] != null)
            {
                hi = (List<HistoryItem>)HttpContext.Current.Session["HistoryList"];
            }

            if (hi != null)
            {
                if (count < hi.Count){
                    hi = hi.GetRange(hi.Count - (count), count);
                }   
                else
                {
                    hi.Sort(delegate(HistoryItem hi1, HistoryItem hi2)
                    {
                        return hi1.ItemLabel.CompareTo(hi2.ItemLabel);
                    });


                    hi = hi.GetRange(0, hi.Count);
                }


            }


            return hi; ;
        }


        public List<HistoryItem> GetItems()
        {
            List<HistoryItem> hi = null;

            if (HttpContext.Current.Session["HistoryList"] != null)
            {
                hi = (List<HistoryItem>)HttpContext.Current.Session["HistoryList"];
            }

            return hi;

        }

    }
}
