// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

 
contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;
  
    uint256 public volume;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    constructor() { 
          setPublicChainlinkToken();
          oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
          jobId = "d5270d1c311941d0b08bead21fea7747";
          fee = 0.1 * 10 ** 18; 
        
        }
    
    function requestVolumeData() public returns (bytes32 requestId) 
    {
         Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
          request.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
        
        request.add("path", "RAW.ETH.USD.TOSYMBOL");
       
        return sendChainlinkRequestTo(oracle, request, fee);
    }

      function stringToBytes32(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
  

      function bytes32ToStr(bytes32 _bytes32) public pure returns (string memory) {

    
    bytes memory bytesArray = new bytes(32);
    for (uint256 i; i < 32; i++) {
        bytesArray[i] = _bytes32[i];
        }
    return string(bytesArray);
    }

    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId)
    {


       volume = _volume;
    
    }
    
}
