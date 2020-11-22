pragma solidity >=0.4.22 <0.6.0;

import "./TRC20.sol";
import "../../Ownable.sol";

contract TRC20Mintable is TRC20, Ownable {

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public onlyOwner returns (bool) {
        _mint(to, value);
        return true;
    }

    /**
     * @dev Function to burn tokens
     * @param from The address that will be token burned.
     * @param value The amount of tokens.
     * @return A boolean that indicates if the operation was successful.
     */
    function redeem(address from, uint256 value) public onlyOwner returns (bool) {
        _burn(from, value);
        return true;
    }
}
