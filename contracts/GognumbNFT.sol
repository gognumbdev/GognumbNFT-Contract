// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract GognumbNFT is ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint public constant MAX_SUPPLY = 100;
    uint public constant MINT_PRICE = 0.01 ether;
    uint public constant MAX_PER_MINT = 1;

    bool private revealed = false;

    constructor() ERC721("GognumbNFT","GNFT") {}

    function mintNFT(address recipient,string memory tokenUri) public payable returns (uint256) {
        
        // Check basic value to basic requriement
        require(_tokenIds.current()<=MAX_SUPPLY,"All of GognumbNFT was mint.");
        require(msg.value>=MINT_PRICE,"Require at least 0.01 ether(ETH) to mint GognumbNFT.");
        
        // Increment and get the current token id of this contract
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        // Mint NFT to `recipient` address with the token id `newItemId`
        _safeMint(recipient, newItemId);

        // set uri for the token id `newItemId`
        _setTokenURI(newItemId, tokenUri);

        return newItemId;
    }

    // Reveal token URI of this contract tokens  
    function reveal() public {
        revealed = true;
    }

    // Get token URI by token id -> if token URI was not reveal yet,reject
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (revealed == true) {
            return super.tokenURI(tokenId);
        } else {
            return "Token URI of this contract was not reveal for public yet.";
        }
    }

    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIds.current();
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Withdraw fund from this smart contract to payee with the amount that was request
    function withdraw(address payable payee,uint256 amount) public payable onlyOwner returns (bool) {
        // Get Ether balance of this contract
        uint contractBalance = address(this).balance;

        // Check balance of this contract with require parameters
        require(contractBalance > 0 , "No ether to withdraw from the contract");
        require(contractBalance > amount , "Ether in the contract is not enough to the amount you need to withdraw.");

        // Transfer Ether (ETH) in this smart contract to payee
        bool sent = payee.send(amount);
        require(sent,"Withdrawal contract balance to payee fail");
        
        return sent;
    }
}