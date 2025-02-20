// Minor update: Comment added for GitHub contributions
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMinting is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    uint256 public mintingFee;
    
    event Minted(address indexed minter, uint256 tokenId, string tokenURI);

    constructor(uint256 _mintingFee) ERC721("MyNFTCollection", "MNFTC") {
        mintingFee = _mintingFee;
    }

    modifier hasFee() {
        require(msg.value >= mintingFee, "Insufficient funds for minting");
        _;
    }

    // Mint NFT
    function mintNFT(address to, string memory tokenURI) public payable hasFee returns (uint256) {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        nextTokenId++;

        emit Minted(to, tokenId, tokenURI);
        return tokenId;
    }

    // Withdraw contract balance to owner
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Update minting fee
    function setMintingFee(uint256 _mintingFee) external onlyOwner {
        mintingFee = _mintingFee;
    }

    // Get contract balance
    function getContractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
