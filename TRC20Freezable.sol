pragma solidity >=0.4.22 <0.6.0;

import "../../libs/SafeMath.sol";
import "./TRC20.sol";
import "../../Ownable.sol";
import "../../Context.sol";


contract TRC20Freezable is TRC20, Ownable, Context {
    using SafeMath for uint;

    event Frozen(address account, uint amount);
    event Thawed(address account, uint amount);
    event UpdateMinFreezeValue(uint value);
    event UpdateMinFreezePeriod(uint value);
    event StakingStatusSet(bool status);

    uint min_freeze_value = 0;
    uint min_freeze_period = 0;
    bool staking = true;

    uint256 private _totalFrozen;

    mapping(address => uint) private _frozenBalance;
    mapping(address => uint) private _frozenFrom;

        modifier withAvailableBalance(uint value) {
        require(value <= balanceOf(_msgSender()), "Deposit balance overflow");
        require(value >= min_freeze_value, "Low deposit");
        _;
    }

    modifier canFreeze(uint value) {
        require(true == staking, "staking is off");
        _;
    }

    modifier canUnfreeze() {
        require(frozenBalanceOf(_msgSender()) > 0 && now > _frozenFrom[_msgSender()].add(min_freeze_period), "You cannot unfreeze tokens!");
        _;
    }

    function stackingStatus() public view returns (bool) {
        return staking;
    }

    function setStakingTo(uint value) public onlyOwner returns (bool) {
        if (value >= 1 && staking == true) {
            staking = true;
        } else {
            staking = false;
        }
        emit StakingStatusSet(staking);
        return true;
    }

    function setMinFreezeValue(uint value) public onlyOwner returns (bool) {
        min_freeze_value = value;
        emit UpdateMinFreezeValue(value);
        return true;
    }

    function setMinFreezePeriod(uint value) public onlyOwner returns (bool) {
        min_freeze_period = value;
        emit UpdateMinFreezePeriod(value);
        return true;
    }

    function getMinFreezeValue() public view returns (uint) {
        return min_freeze_value;
    }

    function getMinFreezePeriod() public view returns (uint) {
        return min_freeze_period;
    }

    function frozenBalanceOf(address owner) public view returns (uint) {
        return _frozenBalance[owner];
    }

    function availableToFreezeOf(address owner) public view returns (uint) {
        return balanceOf(owner).sub(frozenBalanceOf(owner));
    }

    function totalFrozen() public view returns (uint) {
        return _totalFrozen;
    }

    function freeze(uint256 amount)
    public
    withAvailableBalance(amount)
    canFreeze(amount)
    returns (bool frozen)
    {
        _frozenBalance[_msgSender()] = _frozenBalance[_msgSender()].add(amount);
        _frozenFrom[_msgSender()] = now;
        _balances[_msgSender()] = _balances[_msgSender()].sub(amount);
        _totalFrozen = _totalFrozen.add(amount);

        emit Frozen(_msgSender(), amount);
        emit Transfer(_msgSender(), address(this), amount);

        return true;
    }

    function unfreeze() public canUnfreeze returns (bool frozen) {
        uint _balance = frozenBalanceOf(_msgSender());
        _frozenBalance[_msgSender()] = _frozenBalance[_msgSender()].sub(_balance);

        require(frozenBalanceOf(_msgSender()) == 0, "You cannot transfer frozen balance!");

        _balances[_msgSender()] = _balances[_msgSender()].add(_balance);
        _totalFrozen = _totalFrozen.sub(_balance);

        emit Thawed(_msgSender(), _balance);
        emit Transfer(address(this), _msgSender(), _balance);

        return true;
    }
}
