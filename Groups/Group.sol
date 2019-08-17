//pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
import "./element.sol";
import "./bo.sol";
contract Group {
    struct tup{
        uint a;
        uint b;
    }
    address F;
    address e;
    mapping(address => element) elements;
    mapping(address => uint) filter;
    mapping(address => uint) inv;
    mapping(address => uint) rel;
    constructor(uint id, uint[] memory g) public { //all generators/axioms are mapped to even addresses
        e = address(2*id);
        filter[e] = 1;
        for(uint i =0; i < g.length; i ++){
            uint absolute_token = 3*g[i];
            filter[address(absolute_token)] = 1;
            rel[address(absolute_token)] = absolute_token;
        }
    }
    function max(uint a, uint b)public returns (uint m){
        if(a<=b){return b;}
        else{return a;}
    }
    function c(uint a, uint b)public returns (uint x){ //cantor pairing funtion
        x = (a + b)*(a + b + 1);
        x = x/2;
        x +=b;
        return x;

    }
    function X(uint a, uint b)public returns (uint x){// cantor pairing function mapping N-> 2N + 1
        if(a ==0 && b == 0){return 0;}          //this is also a mapping from tokens a,b to
        return ((a+b)*(a+b+1))/2 + b;                                   //the token a AND b. Returning min value guarentees
                                                            //that aXb = bXa

    }
    function X3(uint a, uint b) public returns (uint x){
        uint x1 = 3*X(a,b) + 1;
        uint x2 = 3*X(b,a) + 1;
        addrel(x1,x1);
        addrel(x2,x1);
        return x1;
    }
    function sqrt(uint x) public returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
    function Xinv(uint z) public returns (uint a,uint b){
        uint w = (sqrt(8*z + 1) - 1)/2;
        uint t = (w*w + w)/2;
        uint a = z-t;
        uint b = w-a;
        return (b,a);
    }

    function T(uint a, uint b)public returns (uint y){//maps address' a,b to their xor value within the group
        uint la = lor(a);
        uint lb = lor(b);
        uint x = (filter[address(la)] + filter[address(lb)]) % 2;
        if (x > 0){
            if (filter[address(la)] > 0){
                return a;
            }
            else{ return b; }
        }
        else{ return 0;}
    }
    function gen(uint a) public returns (uint b) {
        return 2*a;
    }
    function interpret(uint a)public returns (uint x){
        if(a%3 == 0){
            return filter[address(lor(a))];
        }
        else if(a%3 == 1){
            (uint p, uint q) = Xinv((a-1)/3);
            return interpret(lor(p))*interpret(q);
        }
        else{
            return (1+filter[address(getInv(a))]);
        }
    }
    function join(uint a, uint b)public returns (uint x){
        uint pq_b = X3(a,b);
        //filter[address(pq_b)] = filter[address(a)]*filter[address(b)];
            if (a%3 == 1){
                (uint p, uint q) = Xinv((a-1)/3);
                uint qb = X3(q,b);
                //filter[address(qb)] = filter[address(q)]*filter[address(b)];
                uint p_qb = X3(p,qb);
                addrel(p_qb,pq_b); //enforces associativity;
            }
            return pq_b;
    }
    function op(uint a, uint b, uint o) public returns (uint x) {
        if(o == 1){
            uint j = join(a,b);
            return j;
        }
        else if (o==2){return T(a,b);}
        else{return 0;}
    }
    function proveElement(uint[][] memory proof) public {
        for(uint i = 0; i < proof.length; i ++){
            uint operation = proof[i][0];
            uint lastres=proof[i][1];
            for(uint j = 1; j < proof[i].length -1; j ++){
                uint ad = op(lastres,proof[i][j+1],operation);
                lastres = ad;


            }
        }
    }
    //function setInverse(uint a) public{
    //     uint ainv = getInv(a);
    //     uint ival = (1 + filter[address(a)])%2;
    //     filter[address(ainv)] = ival;
    //     if (ival == 1){ }
    // }
    function getInv(uint a) public returns (uint b){
        if(a%3 == 2){
            return (a + 1)/3;
        }
        else{
            return max(3*a-1,0);
        }
    }
    function getval(uint a)public returns (uint b) {
        return filter[address(a)];
    }
    function getRel(uint a)public returns (uint b){
        uint x = rel[address(a)];
        if (x == 0){rel[address(a)] = a;}
        return rel[address(a)];
    }
    function addrel(uint a, uint b) public{
        if(lor(a) != lor(b)){
            rel[address(a)] = b;
        }
    }
    function lor(uint a) public returns (uint r){
        uint r = getRel(a);
        while(rel[address(r)]!=r){
            r = rel[address(r)];
        }
        return r;
    }


}
