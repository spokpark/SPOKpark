pragma solidity >=0.4.22 <0.6.0;

import "../../Ownable.sol";
import "./TRC20Mintable.sol";
import "./TRC20Detailed.sol";
import "./TRC20Freezable.sol";

contract Token is Ownable, TRC20Detailed, TRC20Mintable, TRC20Freezable {
    using SafeMath for uint;

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol,
        uint8 tokenDecimal
    )
    TRC20Detailed(tokenName, tokenSymbol, tokenDecimal)
    Ownable(msg.sender)
    public
    {
        mint(owner(), initialSupply * 10**uint(tokenDecimal));
    }

    function transfer(address to, uint256 value) public returns (bool) {
        return super.transfer(to, value);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        return super.approve(spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }
}
