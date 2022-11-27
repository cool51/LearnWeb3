// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/* 
Contract to mint 10 NFT

-constructor to_baseTokenURI  and constructor t
-minting funtion 
    `tokeIdmustt exceed 10
    `must pay 0.01 ether
    `_safeMInt

-withdraw function to transfer all money in contract to owner

 */

contract LW3Punks is ERC721Enumerable, Ownable {
    //set base token uri which can be later concenated to tokenURI to get full URI

    using Strings for uint256;

    string _baseTokenURI;
    uint256 public _price = 0.01 ether;
    uint256 public maxTokenIds = 10;
    uint256 public mintedTokenIds;

//pasue contract if times of emergency/hacks 
    bool public _paused;


modifier onlyWhenNotPaused{
    require(! _paused,"Contract is currently paused, plesae contact owners for further enquiry ");
    _;
}

function setPause(bool val)public onlyOwner{
    _paused=val;
}

    constructor(string memory _baseURI) ERC721("LW3Punks", "LW3P") {
        _baseTokenURI = _baseURI;
    }

//overriding baseuri func af openzepplin to return our baseuri
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }


    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();

        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    function mint() public payable onlyWhenNotPaused {
        require(mintedTokenIds < maxTokenIds, "All NFT aleready minted");
        require(
            msg.value >= _price,
            "Insufficent ethers sent , please send above 0.01 ether"
        );
        mintedTokenIds += 1;
        _safeMint(msg.sender, mintedTokenIds);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether");
    }

    //fallback to receive ether when msg.data is empty
    receive() external payable {}

    //fallback to receive ether when msg.data is not empty
    fallback() external payable {}
}
