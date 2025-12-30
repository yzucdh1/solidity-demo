// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SimpleNFT {
    struct NFT {
        uint256 id;
        address owner;
        uint256 price;
        bool forSale;
    }

    mapping(uint256=>NFT) public nfts;
    uint256 public nftCount;
    NFT[] public salingList;
    address public immutable admin;

    constructor() {
        admin = msg.sender;
    }

    event CreateNFT(uint256 indexed id, address indexed owner, uint256 price);
    event Buy(address indexed buyer, uint256 indexed id, uint256 price);
    event Up(uint256 indexed id, address indexed owner);
    event Down(uint256 indexed id, address indexed owner);

    function createNFT(address _owner, uint256 _price) public returns (uint256) {
        require(msg.sender == admin, "only admin can do this");
        uint256 id = nftCount++;
        nfts[id] = NFT({
            id: id,
            owner: _owner,
            price: _price,
            forSale: false
        });
        emit CreateNFT(id, _owner, _price);
        return id;
    }

    function up(uint256 id) public {
        require(msg.sender == admin, "only admin can do this");
        require(id < nftCount, "NFT does not exist");
        NFT storage nft = nfts[id];
        require(!nft.forSale, "the NFT is on saling");
        nft.forSale = true;
        salingList.push(nft);
        emit Up(id, nft.owner);
    }

    function down(uint256 id) public {
        require(msg.sender == admin, "only admin can do this");
        require(id < nftCount, "NFT does not exist");
        NFT storage nft = nfts[id];
        require(nft.forSale, "the NFT is not on saling");
        nft.forSale = false;
        uint len = salingList.length;
        uint index = 0;
        for (uint i = 0; i < len; i++) {
            if (salingList[i].id == id) {
                index = i;
            }
        }
        // 从在售列表删除
        salingList[index] = salingList[len - 1];
        salingList.pop();
        emit Down(id, nft.owner);
    }

    function buy(uint256 id, address buyer) public payable {
        require(id < nftCount, "NFT does not exist");
        NFT storage nft = nfts[id];
        require(nft.forSale, "the NFT is not on saling");
        require(msg.value == nft.price, "the price is not correct");
        nft.owner = buyer;
        nft.forSale = false;
        uint len = salingList.length;
        uint index = 0;
        for (uint i = 0; i < len; i++) {
            if (salingList[i].id == id) {
                index = i;
            }
        }
        // 从在售列表删除
        salingList[index] = salingList[len - 1];
        salingList.pop();
        emit Buy(buyer, id, nft.price);
    }

    function querySalingList() public view returns(NFT[] memory) {
        return salingList;
    }

}