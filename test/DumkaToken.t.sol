//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "forge-std/Test.sol";
import "../src/DumkaToken.sol";

contract DumkaTokenTest is Test {
    DumkaToken token;
    address owner = address(this);
    address elizer = address(0x1);
    address faith = address(0x2);

    uint256 constant INITIAL_SUPPLY = 1_000_000;

    function setUp() public{
        token = new DumkaToken(
            "DumkaToken",
            "DUM",
            INITIAL_SUPPLY
        );
    }
    /*DEPLOYMENT*/
    function testInitialSupplyMintedToOwner()
    public {
        uint256 expectedSupply = INITIAL_SUPPLY * 10 ** token.decimals();
        assertEq(token.totalSupply(), expectedSupply);
        assertEq(token.balanceOf(owner), expectedSupply);
    }
    /*TRANSFERS*/
    function testTransferBetweenWallets() public {
        uint256 amount = 1_000 * 10 ** token.decimals();
        token.transfer(elizer, amount);

        assertEq(token.balanceOf(elizer), amount);
        assertEq(
            token.balanceOf(owner),
            token.totalSupply() - amount
        );
    }
    /*MINTING*/

    function testOwnerCanMint() public {
        uint256 amount = 500 * 10 ** token.decimals();
        token.mint(faith, amount);
        assertEq(token.balanceOf(faith), amount);
    }
    function testNonOwnerCannotMint() public {
        vm.prank(elizer);
        vm.expectRevert();
        token.mint(elizer, 100);
    }
    /*PAUSING*/

    function testPauseBlocksTransfers() public {
        token.pause();
        vm.expectRevert();
        token.transfer(elizer, 100);
    }
    function testUnpauseAllowsTransfers() public {
        token.pause();
        token.unpause();
        token.transfer(elizer, 100);
        assertEq(token.balanceOf(elizer), 100);
    }

    /*BURNING*/

    function testBurnReducesTotalSupply() public {
        uint256 burnAmount = 1_000 * 10 ** token.decimals();
        uint256 supplyBefore = token.totalSupply();

        token.burn(burnAmount);
        assertEq(
            token.totalSupply(),
            supplyBefore - burnAmount
        );
    }
}