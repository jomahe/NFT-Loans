// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// import "./NFT.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Collateral is ERC721URIStorage {
    uint public tokenCount;

    constructor() ERC721("Collateral", "CLT") {}

    function mint(string memory _tokenURI) external returns(uint) {
        _safeMint(msg.sender, ++tokenCount);
        _setTokenURI(tokenCount, _tokenURI);
        return tokenCount;
    }
}