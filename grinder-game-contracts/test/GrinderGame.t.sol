// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@std/Test.sol";
import "../src/GrinderGame.sol";
import "../src/Grinder.sol";
import "../src/GrinderResources.sol";


contract GinderTest is Test {

    GrinderGame public game;
    Grinder public grinderChars;
    GrinderResources public grinderResources;


    function setUp() public {

        game = new GrinderGame("ipfs://IMAGE_CID/", "ipfs://JSONS_CID/");

        grinderChars = game.grinderCharacters();
        grinderResources = game.grinderResources();

        vm.warp(1641070800);
        
    }

    function testGrind() public {
        address player = vm.addr(0xa11ce);

        vm.startPrank(player);
        
        grinderChars.mint();
        uint256 characterId = grinderChars.totalSupply()-1;

        assertEq(grinderChars.balanceOf(player), 1);
        assertEq(grinderChars.level(characterId), 0);
        assertEq(grinderChars.energy(characterId), 1);
        assertEq(grinderResources.balanceOf(player, 1), 0);

        console.log("Char #%i, level %i, energy %i", characterId, grinderChars.level(characterId), grinderChars.energy(characterId));
        console.log("Resource #1 bal %i", grinderResources.balanceOf(player, 1));

        game.grind(characterId, 1);

        assertEq(grinderChars.level(characterId), 1);
        assertEq(grinderChars.energy(characterId), 0);
        assertEq(grinderResources.balanceOf(player, 1), 1);

        console.log("Char #%i, level %i, energy %i", characterId, grinderChars.level(characterId), grinderChars.energy(characterId));
        console.log("Resource #1 bal: %i", grinderResources.balanceOf(player, 1));

    }
    
}
