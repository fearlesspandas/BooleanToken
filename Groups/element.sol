pragma solidity >=0.4.22 <0.6.0;
import "./Group.sol";
contract element{
    address G;
    address content;
    mapping(address => address) X; //this will represent the group action over this element
    constructor(uint g,uint c) public {
        G=address(g);
        content = address(c);
    }


}
