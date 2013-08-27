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
using System.ServiceModel;
using System.ServiceModel.Activation;
using Connects; //.Profiles.Service.DataContracts;
//using Connects.Profiles.Utility;
using System.Xml;


using System.Diagnostics;
using System.Web.Security;

namespace Connects.Profiles.Service.ServiceImplementation
{
    [ServiceBehavior(IncludeExceptionDetailInFaults = true), AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ProfileServiceAdapter
    {
        public Connects.Profiles.Service.DataContracts.PersonList ProfileSearch(Connects.Profiles.Service.DataContracts.Profiles qd, bool isSecure)
        {
            Connects.Profiles.Service.DataContracts.PersonList pl = null;
            string req = string.Empty;
            string responseXML = string.Empty;

            try
            {
                DataIO ps = new DataIO();
                XmlDocument searchrequest = new XmlDocument();
                Utility.Namespace namespacemgr = new Connects.Profiles.Utility.Namespace();
                

                Connects.Profiles.Service.DataContracts.Profiles p = new Connects.Profiles.Service.DataContracts.Profiles();

                req = Connects.Profiles.Utility.XmlUtilities.SerializeToString(qd);

                DebugLogging.Log("+++++++++ REQUEST=" + req);

                Type type = typeof(Connects.Profiles.Service.DataContracts.PersonList);

                searchrequest.LoadXml(this.ConvertToRDFRequest(req, qd.Version.ToString()));



                if (qd.QueryDefinition.PersonID != null && qd.Version != 2)
                {
                    qd.QueryDefinition.PersonID = ps.GetPersonID(qd.QueryDefinition.PersonID).ToString();
                }



                if (qd.QueryDefinition.PersonID != null)
                {
                    responseXML = ps.Search(qd.QueryDefinition.PersonID, isSecure).OuterXml;
                }
                else
                {
                    responseXML = ps.Search(searchrequest, isSecure).OuterXml;
                }


                string queryid = string.Empty;
                queryid = qd.QueryDefinition.QueryID;


                if (responseXML == string.Empty)
                {
                    if (queryid == null)
                        queryid = Guid.NewGuid().ToString();


                    responseXML = "<PersonList Complete=\"true\" ThisCount=\"0\" TotalCount=\"0\" QueryID=\"" + queryid + "\" xmlns=\"http://connects.profiles.schema/profiles/personlist\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" />";

                }
                else
                {

                    string version = string.Empty;
                    bool individual = false;


                    version = qd.Version.ToString();

                    if (qd.QueryDefinition.PersonID != null || qd.QueryDefinition.InternalIDList != null)
                        individual = true;

                    responseXML = ps.ConvertV2ToBetaSearch(responseXML, queryid, version, individual);
                }

                DebugLogging.Log("+++++++++ DONE WITH Convert V2 to Beta Search");
                pl = Connects.Profiles.Utility.XmlUtilities.DeserializeObject(responseXML, type) as Connects.Profiles.Service.DataContracts.PersonList;
                DebugLogging.Log("+++++++++ Returned + a total count of = " + pl.TotalCount);

            }
            catch (Exception ex)
            {
                DebugLogging.Log(req + " " + responseXML);
                DebugLogging.Log("ERROR==> " + ex.Message + " STACK:" + ex.StackTrace + " SOURCE:" + ex.Source);
            }

            return pl;

        }


        private string ConvertToRDFRequest(string req, string version)
        {

            string searchstring = string.Empty;
            string exactphrase = string.Empty;
            string fname = string.Empty;
            string lname = string.Empty;

            string ecomid = string.Empty;
            string personid = string.Empty;
            string harvardid = string.Empty;

            string institution = string.Empty;
            string institutionallexcept = string.Empty;
            string department = string.Empty;
            string departmentallexcept = string.Empty;
            string facultyrank = string.Empty;

            string division = string.Empty;
            string divisionallexcept = string.Empty;
            string classuri = "http://xmlns.com/foaf/0.1/Person";
            int limit = 100;
            int offset = 0;
            string sortby = string.Empty;
            string sortdirection = string.Empty;
            string otherfilters = string.Empty;

            XmlDocument newrequest = new XmlDocument();

            XmlDocument request = new XmlDocument();
            req = req.Replace("\n", "").Replace("\r", "");
            req = req.Replace("<?xml version=\"1.0\" encoding=\"utf-16\"?>", "");
            req = req.Replace("xmlns=\"http://connects.profiles.schema/profiles/query\"", "");
            request.LoadXml(req);

            if (request.SelectSingleNode("//Profiles/QueryDefinition/PersonID") != null)           
                personid = request.SelectSingleNode("//Profiles/QueryDefinition/PersonID").InnerText;           
           
            if (request.SelectSingleNode("//Profiles/QueryDefinition/InternalIDList/InternalID[@Name = 'EcommonsUsername']") != null)
                ecomid = request.SelectSingleNode("//Profiles/QueryDefinition/InternalIDList/InternalID[@Name = 'EcommonsUsername']").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/InternalIDList/InternalID[@Name = 'HarvardID']") != null)
                harvardid = request.SelectSingleNode("//Profiles/QueryDefinition/InternalIDList/InternalID[@Name = 'HarvardID']").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/Keywords/KeywordString") != null)
                searchstring = request.SelectSingleNode("//Profiles/QueryDefinition/Keywords/KeywordString").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/Keywords/KeywordString/@MatchType") != null)
                exactphrase = request.SelectSingleNode("//Profiles/QueryDefinition/Keywords/KeywordString/@MatchType").Value;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/Name/FirstName") != null)
                fname = request.SelectSingleNode("//Profiles/QueryDefinition/Name/FirstName").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/Name/LastName") != null)
                lname = request.SelectSingleNode("//Profiles/QueryDefinition/Name/LastName").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DepartmentName") != null)
                department = request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DepartmentName").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DepartmentName/@Exclude") != null)
                departmentallexcept = request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DepartmentName/@Exclude").Value;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DivisionName") != null)
                division = request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DivisionName").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DivisionName/@Exclude") != null)
                divisionallexcept = request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/DivisionName/@Exclude").Value;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/InstitutionName") != null)
                institution = request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/InstitutionName").InnerText;

            if (request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/InstitutionName/@Exclude") != null)
                institutionallexcept = request.SelectSingleNode("//Profiles/QueryDefinition/AffiliationList/Affiliation/InstitutionName/@Exclude").Value;

            if (request.SelectSingleNode("//Profiles/OutputOptions/@StartRecord") != null)
                offset = Convert.ToInt32(request.SelectSingleNode("//Profiles/OutputOptions/@StartRecord").Value);

            if (request.SelectSingleNode("//Profiles/OutputOptions/@MaxRecords") != null)
                limit = Convert.ToInt32(request.SelectSingleNode("//Profiles/OutputOptions/@MaxRecords").Value);

            if (offset > 0)
                offset--;


            if (request.SelectSingleNode("//Profiles/OutputOptions/@SortType") != null)
                sortby = request.SelectSingleNode("//Profiles/OutputOptions/@SortType").Value;



            foreach (XmlNode others in request.SelectNodes("Profiles/QueryDefinition/PersonFilterList/PersonFilter"))
            {
                otherfilters += others.InnerText + ", ";
            }

            if (otherfilters != string.Empty)
                otherfilters = otherfilters.Substring(0, otherfilters.Length - 3);


            DataIO data = new DataIO();

            newrequest = data.SearchRequest(searchstring, exactphrase, fname, lname, institution, institutionallexcept, department, departmentallexcept,
                 division, divisionallexcept, classuri, limit.ToString(), offset.ToString(), sortby, sortdirection, otherfilters, personid, ecomid, harvardid);


            return newrequest.InnerXml;

        }


        public Connects.Profiles.Service.DataContracts.PersonList GetPersonFromPersonId(int personId)
        {
            Connects.Profiles.Service.DataContracts.QueryDefinition qd = new Connects.Profiles.Service.DataContracts.QueryDefinition();
            Connects.Profiles.Service.DataContracts.Profiles profiles = new Connects.Profiles.Service.DataContracts.Profiles();
            profiles.Version = 2;
            profiles.QueryDefinition = qd;
            profiles.QueryDefinition.PersonID = personId.ToString();

            Connects.Profiles.Service.DataContracts.OutputOptions oo = new Connects.Profiles.Service.DataContracts.OutputOptions();
            oo.SortType = Connects.Profiles.Service.DataContracts.OutputOptionsSortType.QueryRelevance;
            oo.StartRecord = "0";

            Connects.Profiles.Service.DataContracts.OutputFilterList ofl = new Connects.Profiles.Service.DataContracts.OutputFilterList();
            Connects.Profiles.Service.DataContracts.OutputFilter of = new Connects.Profiles.Service.DataContracts.OutputFilter();
            of.Summary = false;
            of.Text = "CoAuthorList";

            ofl.OutputFilter = new List<Connects.Profiles.Service.DataContracts.OutputFilter>();
            ofl.OutputFilter.Add(of);

            oo.OutputFilterList = ofl;
            profiles.OutputOptions = oo;

            bool isSecure = System.Convert.ToBoolean(Connects.Profiles.Utility.ConfigUtil.GetConfigItem("IsSecure"));
            profiles.Version = 2;

            return ProfileSearch(profiles, isSecure);
        }

        public Connects.Profiles.Service.DataContracts.PersonList GetDepartmentPeopleFromPersonId(int personId, int count)
        {
            //thisPerson is the current profile being viewed by a user or process.
            Connects.Profiles.Service.DataContracts.PersonList thisPerson;
            Connects.Profiles.Service.DataContracts.PersonList returnPeople;

            thisPerson = GetPersonFromPersonId(personId);

            Connects.Profiles.Service.DataContracts.QueryDefinition qd = new Connects.Profiles.Service.DataContracts.QueryDefinition();
            Connects.Profiles.Service.DataContracts.Profiles profiles = new Connects.Profiles.Service.DataContracts.Profiles();

            if (Convert.ToInt32(thisPerson.TotalCount) > 0)
            {
                if (thisPerson.Person[0].AffiliationList != null)
                {
                    if (thisPerson.Person[0].AffiliationList.Affiliation.Count > 0)
                    {
                        Connects.Profiles.Service.DataContracts.Affiliation Affiliation = new Connects.Profiles.Service.DataContracts.Affiliation();
                        Connects.Profiles.Service.DataContracts.AffiliationList affList = new Connects.Profiles.Service.DataContracts.AffiliationList();
                        Affiliation.DepartmentName = new Connects.Profiles.Service.DataContracts.AffiliationDepartmentName();
                        Affiliation.InstitutionName = new Connects.Profiles.Service.DataContracts.AffiliationInstitutionName();

                        foreach (Connects.Profiles.Service.DataContracts.AffiliationPerson aff in thisPerson.Person[0].AffiliationList.Affiliation)
                        {
                            if (aff.Primary)
                            {
                                Affiliation.DepartmentName.Text = aff.DepartmentName;
                                Affiliation.InstitutionName.Text = aff.InstitutionName;

                            }
                        }
                        affList.Affiliation = new List<Connects.Profiles.Service.DataContracts.Affiliation>();
                        affList.Affiliation.Add(Affiliation);

                        qd.AffiliationList = affList;

                        profiles.QueryDefinition = qd;

                        Connects.Profiles.Service.DataContracts.OutputOptions oo = new Connects.Profiles.Service.DataContracts.OutputOptions();
                        oo.SortType = Connects.Profiles.Service.DataContracts.OutputOptionsSortType.QueryRelevance;
                        oo.StartRecord = "0";
                        oo.MaxRecords = count.ToString();

                        profiles.OutputOptions = oo;


                        bool isSecure = System.Convert.ToBoolean(Connects.Profiles.Utility.ConfigUtil.GetConfigItem("IsSecure"));
                        profiles.Version = 2;
                        returnPeople = ProfileSearch(profiles, isSecure);

                        //Filter out the current profile you are viewing.
                        if (Convert.ToInt32(thisPerson.ThisCount) > 0)
                        {
                            returnPeople.Person.RemoveAll(x => x.PersonID == thisPerson.Person[0].PersonID);
                        }

                        return returnPeople;
                    }
                }
            }

            return thisPerson;
        }


        public int GetPersonIdFromInternalId(string internalTag, string internalValue)
        {
            Connects.Profiles.Service.DataContracts.QueryDefinition qd = new Connects.Profiles.Service.DataContracts.QueryDefinition();
            Connects.Profiles.Service.DataContracts.Profiles profiles = new Connects.Profiles.Service.DataContracts.Profiles();
            int personId = 0;

            Connects.Profiles.Service.DataContracts.InternalIDList internalIdList = new Connects.Profiles.Service.DataContracts.InternalIDList();
            List<Connects.Profiles.Service.DataContracts.InternalID> intIdList = new List<Connects.Profiles.Service.DataContracts.InternalID>();
            Connects.Profiles.Service.DataContracts.InternalID intId = new Connects.Profiles.Service.DataContracts.InternalID();

            intId.Name = internalTag;
            intId.Text = internalValue;

            intIdList.Add(intId);

            internalIdList.InternalID = intIdList;

            profiles.QueryDefinition = qd;
            profiles.QueryDefinition.InternalIDList = internalIdList;

            Connects.Profiles.Service.DataContracts.OutputOptions oo = new Connects.Profiles.Service.DataContracts.OutputOptions();
            oo.SortType = Connects.Profiles.Service.DataContracts.OutputOptionsSortType.QueryRelevance;
            oo.StartRecord = "0";

            profiles.OutputOptions = oo;
            bool isSecure = System.Convert.ToBoolean(Connects.Profiles.Utility.ConfigUtil.GetConfigItem("IsSecure"));
            profiles.Version = 2;
            Connects.Profiles.Service.DataContracts.PersonList resp = ProfileSearch(profiles, isSecure);

            personId = Convert.ToInt32(resp.Person[0].PersonID);

            return personId;
        }




        public Connects.Profiles.Service.DataContracts.PublicationMatchDetailList GetProfilePublicationMatchSummary(Connects.Profiles.Service.DataContracts.Profiles qd, bool isSecure)
        {
            qd.Version = 2;

            Connects.Profiles.Service.DataContracts.PersonList pl = ProfileSearch(qd, isSecure);
            Connects.Profiles.Service.DataContracts.PublicationMatchDetailList pubMatch = new Connects.Profiles.Service.DataContracts.PublicationMatchDetailList();
            HashSet<string> searchPhraseDistinct = new HashSet<string>();
            HashSet<string> publicationPhraseDistinct = new HashSet<string>();

            if (pl != null)
            {

                foreach (Connects.Profiles.Service.DataContracts.Publication pub in pl.Person[0].PublicationList)
                {

                    foreach (Connects.Profiles.Service.DataContracts.PublicationMatchDetail pubMatchDetail in pub.PublicationMatchDetailList)
                    {
                        Connects.Profiles.Service.DataContracts.PublicationMatchDetail pubMatchDetailStripped = new Connects.Profiles.Service.DataContracts.PublicationMatchDetail();
                        pubMatchDetailStripped.SearchPhrase = pubMatchDetail.SearchPhrase;

                        if (!searchPhraseDistinct.Contains(pubMatchDetail.SearchPhrase))
                        {
                            pubMatch.Add(pubMatchDetailStripped);

                            searchPhraseDistinct.Add(pubMatchDetail.SearchPhrase);
                        }

                        foreach (Connects.Profiles.Service.DataContracts.PublicationPhraseDetail pubPhraseDetail in pubMatchDetail.PublicationPhraseDetailList)
                        {

                            //PublicationPhraseDetail pubPhraseDetailStripped = new PublicationPhraseDetail();
                            //pubPhraseDetailStripped.PublicationPhrase = pubPhraseDetail.PublicationPhrase;

                            //PublicationMatchDetail pmd = pubMatch.Find(delegate(PublicationMatchDetail t) { return t.SearchPhrase == pubMatchDetail.SearchPhrase; });

                            //// Handle the structure
                            //if (!publicationPhraseDistinct.Contains(pubPhraseDetail.PublicationPhrase))
                            //{
                            //    if (pmd.PublicationPhraseDetailList == null)
                            //        pmd.PublicationPhraseDetailList = new PublicationPhraseDetailList();

                            //    pmd.PublicationPhraseDetailList.Add(pubPhraseDetailStripped);

                            //    publicationPhraseDistinct.Add(pubPhraseDetail.PublicationPhrase);
                            //}

                            //// Get the Phrase Measurements
                            //PublicationPhraseDetail ppd = pmd.PublicationPhraseDetailList.Find(delegate(PublicationPhraseDetail t) { return t.PublicationPhrase == pubPhraseDetail.PublicationPhrase; });
                            //ppd.PhraseMeasurements = pubPhraseDetail.PhraseMeasurements;

                            //if (ppd.PublicationList == null)
                            //    ppd.PublicationList = new PublicationList();
                            //ppd.PublicationList.Add(pub);
                            Connects.Profiles.Service.DataContracts.PublicationMatchDetail pmd = pubMatch.Find(delegate(Connects.Profiles.Service.DataContracts.PublicationMatchDetail t) { return t.SearchPhrase == pubMatchDetail.SearchPhrase; });

                            if (pmd.PublicationPhraseDetailList == null)
                                pmd.PublicationPhraseDetailList = new Connects.Profiles.Service.DataContracts.PublicationPhraseDetailList();

                            pubPhraseDetail.Publication = pub;
                            pmd.PublicationPhraseDetailList.Add(pubPhraseDetail);
                        }

                    }

                }

            }

            // IEnumerable<PublicationMatchDetail> noduplicates = pubMatch.Distinct();

            return pubMatch;

        }


        #region Validation Code

        private bool ValidateSearchRequest(string requestXML)
        {
            return ValidateXML("ProfileQueryXSD", requestXML);
        }

        private bool ValidateSearchResponse(string responseXML)
        {
            return ValidateXML("ProfileResponseXSD", responseXML);
        }

        private bool ValidateXML(string configItem, string xmlToCheck)
        {
            Connects.Profiles.Utility.XmlValidate xmlValidate = new Connects.Profiles.Utility.XmlValidate();
            bool validated = false;
            string xsdPath = Connects.Profiles.Utility.ConfigUtil.GetConfigItem(configItem);

            validated = xmlValidate.ValidateXml(xmlToCheck, xsdPath);

            return validated;
        }
        #endregion
    }
}
