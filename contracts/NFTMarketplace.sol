// SPDX-License-Identifier: UNLICENSED 
// Have to have at the start of every sol doc
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {

    using Counters for Counters.Counter;  //enable counter utility
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listingPrice = 0.025 ether; 

    address payable owner;

    mapping(uint256 => MarketItem) private idToMarketItem; //Mapping a specific id (idToMarketItem) to the item (MarketItem)

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    // An event that is triggered upon some action
    event MarketItemCreated (
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    constructor() ERC721("Metaverse Tokens", "METT"){
        owner = payable(msg.sender); //owner of the contract is the one deploying the msg
    }

    function updateListingPrice(uint _listingPrice) public payable {
        require(owner == msg.sender, "Only MmarketPlace owner can update the listing price");

        listingPrice = _listingPrice;
    }

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }
    // A function for making an NFT
    function createToken(string memory tokenURI, uint256 price) public payable returns (uint) {
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
    
        _mint(msg.sender, newTokenId); //_mint function is used to create an NFT
        _setTokenURI(newTokenId, tokenURI);

        createMarketItem(newTokenId, price); //Custom function to list the newly created NFT on our Marketplace

        return newTokenId;
    }
    // A function called when a seller lists an NFT on the marketplace
    function createMarketItem(uint256 tokenId, uint256 price) private {
        require(price>0, "Price must be at least 1");
        require(msg.value == listingPrice, "Price must be equal to listing price"); 
        //msg.value refers to the actual amount that the seller is sending to the owner for listing the NFT.

        idToMarketItem[tokenId] = MarketItem(
            tokenId, 
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender, address(this), tokenId);

        emit MarketItemCreated(tokenId, msg.sender, address(this), price, false);
    }
    // A function called to resell an NFT bought by a user
    function resellToken(uint256 tokenId, uint256 price) public payable {
        require(idToMarketItem[tokenId].owner == msg.sender, "Only item owner can perform this operation");
        require(msg.value == listingPrice, "Price must be equal to listing price");

        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].price = price;
        idToMarketItem[tokenId].seller = payable(msg.sender);
        idToMarketItem[tokenId].owner = payable(address(this));

        _itemsSold.decrement(); //Since we are listing an already sold item again

        _transfer(msg.sender, address(this), tokenId);
    }
    // A function called when user purchases an NFT
    function createMarketSale(uint256 tokenId) public payable {
        //Send from the marketplace to the person that bought the NFT
        uint price = idToMarketItem[tokenId].price;

        require(msg.value == price, "Please submit the asking price in order to purchase the token");

        idToMarketItem[tokenId].owner == payable(msg.sender); //msg sender is the one buying the NFT
        idToMarketItem[tokenId].sold == true; 
        idToMarketItem[tokenId].seller == payable(address(0)); //It doesnt belong to any specific wallet now

        _itemsSold.increment();

        _transfer(address(this), msg.sender, tokenId);

        payable(owner).transfer(listingPrice);
        payable(idToMarketItem[tokenId].seller).transfer(msg.value);


    }
    // A function to fetch all unsold items in the (belonging to the) marketplace
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _tokenIds.current();
        uint unsoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);

        for (uint256 i = 0; i < itemCount; i++) {
            if(idToMarketItem[i+1].owner == address(this)) {
                uint currentId = i+1;
                MarketItem storage currentItem = idToMarketItem[currentId];

                items[currentIndex] = currentItem;

                currentIndex += 1;
            }
        }

        return items;
    }
    // A function that returns items that the suer has purchased
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i = 0; i < totalItemCount; i++) {
            if(idToMarketItem[i+1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);

        for (uint256 i = 0; i < totalItemCount; i++) {
            if(idToMarketItem[i+1].owner == msg.sender) {
                uint currentId = i+1;

                MarketItem storage currentItem = idToMarketItem[currentId];

                items[currentIndex] = currentItem;

                currentIndex += 1;
            }
        }

        return items;

    }
    // A function that returns the items that the seller has listed
    function fetchItemsListed() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i = 0; i < totalItemCount; i++) {
            if(idToMarketItem[i+1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);

        for (uint256 i = 0; i < totalItemCount; i++) {
            if(idToMarketItem[i+1].seller == msg.sender) {
                uint currentId = i+1;

                MarketItem storage currentItem = idToMarketItem[currentId];

                items[currentIndex] = currentItem;

                currentIndex += 1;
            }
        }

        return items;
    }

}

