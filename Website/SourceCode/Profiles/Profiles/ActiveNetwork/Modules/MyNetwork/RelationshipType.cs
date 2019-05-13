using System;
using System.Collections.Generic;
using System.Data.SqlClient;
namespace Profiles.ActiveNetwork.Modules.MyNetwork
{
    public class RelationshipType
    {
        public RelationshipType(string text, string value, bool selected)
        {
            this.Text = text;
            this.Value = value;
            this.Selected = selected;
        }
        public string Text { get; set; }
        public string Value { get; set; }
        public bool Selected { get; set; }


    }
    public static class RelationshipTypeUtils
    {


        public static List<RelationshipType> GetRelationshipTypes(Int64 subject)
        {
            Profiles.Framework.Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            SqlDataReader reader;



            List<RelationshipType> RelationshipTypes = new List<RelationshipType>();

            //Int64 subject = 0;

            reader = data.GetActiveNetwork(subject, true);

            while (reader.Read())
            {
                RelationshipTypes.Add(new RelationshipType(reader["RelationshipName"].ToString(), reader["RelationshipType"].ToString(), Convert.ToBoolean(reader["DoesExist"])));
            }

            return RelationshipTypes;
        }

    }



}