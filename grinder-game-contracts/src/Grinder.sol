// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "./Base64.sol";
import {GrinderGame} from "./GrinderGame.sol";

contract Grinder is ERC721 {

    using Strings for uint256;

    error TokenDoesNotExist(uint256 tokenId);
    error NotAllowed();

    struct Character {
        uint256 level;
        uint256 lastGrinded;
    }

    mapping(uint256 => Character) public characters;

    uint256 internal _totalSupply;
    string public imageURI;

    GrinderGame grinderGame; 

    constructor(address _grinderGame, string memory _imageURI) ERC721("Grinder", "GRND") {
        grinderGame = GrinderGame(_grinderGame);
        imageURI = _imageURI;
    }

    function mint() public {
        _safeMint(msg.sender, _totalSupply);
        ++_totalSupply;
        characters[_totalSupply] = Character(1,0);
    }

    function levelUp(uint256 tokenId) public {
        if(!_exists(tokenId)) revert TokenDoesNotExist(tokenId);
        if(msg.sender != address(grinderGame)) revert NotAllowed();
        characters[tokenId].level = characters[tokenId].level + 1;
    }

    function decreaseEnergy(uint256 tokenId) public {
        if(!_exists(tokenId)) revert TokenDoesNotExist(tokenId);
        if(msg.sender != address(grinderGame)) revert NotAllowed();
        characters[tokenId].lastGrinded = block.timestamp;
    }

    function energy(uint256 tokenId) public view returns (uint256) {
        if(!_exists(tokenId)) revert TokenDoesNotExist(tokenId);
        if (lastGrinded(tokenId) + 24*60*60 < block.timestamp) {
            return 1;
        } else {
            return 0;
        }
    }

    function lastGrinded(uint256 tokenId) public view returns (uint256) {
        if(!_exists(tokenId)) revert TokenDoesNotExist(tokenId);
        return characters[tokenId].lastGrinded;
    }

    function level(uint256 tokenId) public view returns (uint256) {
        if(!_exists(tokenId)) revert TokenDoesNotExist(tokenId);
        return characters[tokenId].level;
    }

    function firstGrinder() public view returns (uint256 tokenId) {
        for (uint i; i<_totalSupply; ) {
            if (ownerOf(i) == msg.sender) {
                tokenId = i;
                break;
            }
            unchecked {++i;}
        }
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if(!_exists(tokenId)) revert TokenDoesNotExist(tokenId);

        string memory json = string(abi.encodePacked('{"name": "Grinder #', tokenId.toString(), '", "description": "Grinder Game Character", "image": "',imageURI ,'","attributes": [{"trait_type": "Character", "value": "Grinder"}, {"trait_type": "Level", "value": "', characters[tokenId].level ,'"}]}'));
        return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(json))));
    }
    
}
