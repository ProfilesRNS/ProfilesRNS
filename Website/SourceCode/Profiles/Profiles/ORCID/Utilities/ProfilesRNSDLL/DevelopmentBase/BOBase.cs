namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class BOBase
    {
        public bool IsDataComplete { get; private set; }
        public string DataCompleteMsg { get; private set; }

        public void SetDataComplete(bool pIsDataComplete, string pDataCompleteMsg)
        {
            IsDataComplete = pIsDataComplete;
            DataCompleteMsg = pDataCompleteMsg;
        }

        public BOBase()
        {
            IsDataComplete = true;
            DataCompleteMsg = string.Empty;
        }
    }
}
