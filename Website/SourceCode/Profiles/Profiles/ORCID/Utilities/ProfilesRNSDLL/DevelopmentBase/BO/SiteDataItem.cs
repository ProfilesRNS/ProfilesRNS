using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO
{
    public class SiteDataItem
    {
        private string _text;
        private string _url;
        private int _id;
        private int? _parentId;
        private string _tag;

        public string Text
        {
            get { return _text; }
            set { _text = value; }
        }
        public string Url
        {
            get { return _url; }
            set { _url = value; }
        }
        public int ID
        {
            get { return _id; }
            set { _id = value; }
        }
        public int? ParentID
        {
            get { return _parentId; }
            set { _parentId = value; }
        }
        public string Tag
        {
            get { return _tag; }
            set { _tag = value; }
        }
        public bool IsCurrentPage { get; set; }
        public SiteDataItem(int id, int? parentId, string text, string url, bool isCurrent)
        {
            _id = id;
            _parentId = parentId;
            _text = text;
            _url = url;
            IsCurrentPage = isCurrent;
        }
    }
}
