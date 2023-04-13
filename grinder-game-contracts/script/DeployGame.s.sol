// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.12;

import "@std/console.sol";
import "@std/Script.sol";

import "../src/GrinderGame.sol";
import "../src/Grinder.sol";
import "../src/GrinderResources.sol";


contract DeployGame is Script {
    GrinderGame public game;
    Grinder public grinderChars;
    GrinderResources public grinderResources;

    function run() public {

        //uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_ANVIL");
        //vm.startBroadcast(deployerPrivateKey);
        address sender = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startBroadcast();
        
        game = new GrinderGame("ipfs://IMAGE_CID/", "ipfs://JSONS_CID/");

        grinderChars = game.grinderCharacters();
        grinderResources = game.grinderResources();

        /*
        grinderChars.mint();
        console.log("Minted character. Balance %s : %i", sender, grinderChars.balanceOf(sender));
        console.log("Token id %i. Level %i", grinderChars.totalSupply()-1, grinderChars.level(grinderChars.totalSupply()-1));
        */
        
        vm.stopBroadcast();

    }

}