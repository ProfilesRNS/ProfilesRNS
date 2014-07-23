namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonMessage
    { 
        int PersonMessageID { get; set; } 
        bool PersonMessageIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        string XML_Sent { get; set; } 
        bool XML_SentIsNull { get; set; }
        string XML_Response { get; set; } 
        bool XML_ResponseIsNull { get; set; }
        string ErrorMessage { get; set; } 
        bool ErrorMessageIsNull { get; set; }
        string HttpResponseCode { get; set; } 
        bool HttpResponseCodeIsNull { get; set; }
        bool MessagePostSuccess { get; set; } 
        bool MessagePostSuccessIsNull { get; set; }
        int RecordStatusID { get; set; } 
        bool RecordStatusIDIsNull { get; set; }
        int PermissionID { get; set; } 
        bool PermissionIDIsNull { get; set; }
        string RequestURL { get; set; } 
        bool RequestURLIsNull { get; set; }
        string HeaderPost { get; set; } 
        bool HeaderPostIsNull { get; set; }
        string UserMessage { get; set; } 
        bool UserMessageIsNull { get; set; }
        System.DateTime PostDate { get; set; } 
        bool PostDateIsNull { get; set; }
    } 
} 
