pragma solidity ^0.5.0;

contract MySite {
    
    uint public totalVerifiedSites = 0;
    uint public transCount = 0;
    
    enum URLState {Unknown, Verified}
    
    struct TempDev {
        string name;
        string url;
        string mail;
        uint timeLimit;
    }
    
    struct TempURL {
        string URL;
        string hash;
        uint timeLimit;
    }
    
    mapping (address => TempDev) devs;
    mapping (string => TempURL) urls;
    
    struct VerifiedURL {
        string url;
        address developer;
        string developer_name;
        string developer_mail;
        uint time;
    }
    
    mapping (string => URLState) urlState;
    mapping (string => VerifiedURL) verifiedUrls;
    
    VerifiedURL[] verifiedSites;
    
    modifier URLVerified (string memory _url) {
        require(urlState[_url] != URLState.Verified, "This URL is already verified!");
        _;
    }
    
    modifier URLHashed (string memory _url) {
        require(block.timestamp > urls[_url].timeLimit, "This URL is currently hashed!");
        _;
    }
    
    modifier verifyUserState() {
        require(block.timestamp > devs[msg.sender].timeLimit, "This address is already in a validation window!");
        _;
    }
    
    modifier verifyValidationTime() {
        require(block.timestamp < devs[msg.sender].timeLimit, "The validation window for this address is expired!");
        _;
    }
    
    function addDetails(string memory _name, string memory _url, string memory _mail, string memory _hash) 
    
        public 
        
        URLVerified(_url)
        URLHashed(_url)
        verifyUserState
    
    {
        
        transCount++;
        devs[msg.sender] = TempDev(_name, _url, _mail, block.timestamp + 100);
        urls[_url] = TempURL(_url, _hash, block.timestamp + 100);
        
    }
    
    function verifySite() 
        
        public 
        
        verifyValidationTime
        
    {
        totalVerifiedSites++;
        transCount++;
        
        string memory _dev = devs[msg.sender].url;
        verifiedUrls[_dev] = VerifiedURL(_dev, msg.sender, devs[msg.sender].name, devs[msg.sender].mail, block.timestamp);
        urlState[_dev] = URLState.Verified;
        verifiedSites[totalVerifiedSites] = verifiedUrls[_dev];
    }
    
   function getVerifiedSites(uint _id) public view returns(string memory, address, string memory, string memory, uint) {
       return (
           verifiedSites[_id].url,
           verifiedSites[_id].developer,
           verifiedSites[_id].developer_name,
           verifiedSites[_id].developer_mail,
           verifiedSites[_id].time
           );
   } 
}