pragma solidity >=0.4.22 <0.6.0;
import "./Group.sol";
import "./element.sol";
contract bo {
    address G;
    constructor(Group g) public {
        G=address(g);
    }
}
