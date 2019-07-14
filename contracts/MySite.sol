pragma solidity ^0.5.0;

contract MySite {
    
    uint public totalUnVerifiedSites = 0;
    uint public totalVerifiedSites = 0;
    uint public totalURls = 0;
    
    enum State {Unknown, Hashed, Verified}
    
    State constant defaultState = State.Unknown;
    
    struct Dev {
        address dev;
        string name;
        string url;
        string mail;
        string hash;
        State urlState;
    }
    
    struct URL {
        uint id;
        string hash;
        State urlState;
    }
    
    mapping (uint => Dev) public devs;
    mapping (string => URL) urls;
    
    modifier urlVerified(string memory _url) {
        require(urls[_url].urlState == State.Unknown);
        _;
    }
    
    function addDetails(string memory _name, string memory _url, string memory _mail, string memory _hash) public urlVerified(_url) {
        totalUnVerifiedSites++;
        devs[totalUnVerifiedSites] = Dev(msg.sender, _name, _url, _mail, _hash, State.Hashed);
        
        totalURls++;
        urls[_url] = URL(totalURls, _hash, State.Hashed);
    }

}