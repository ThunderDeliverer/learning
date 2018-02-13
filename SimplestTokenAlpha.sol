pragma solidity ^0.4.18;

contract owned{
  address public owner;

  function owned() public{
    owner = msg.sender;
  }

  modifier onlyOwner{
    require(msg.sender == owner);
    _;
  }
}

contract simplestToken is owned{
    uint256 public totalSupply;
    uint256 public buyPrice;
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function simplestToken(uint256 initialSupply, uint256 initalOwnerSupply, uint256 initialBuyPrice) public{
        balanceOf[this] = initialSupply;              // Give the creator all initial tokens
        balanceOf[msg.sender] = initalOwnerSupply;
        totalSupply = initialSupply;
        buyPrice = initialBuyPrice;
    }

    /*
    *  @dev Event to notify nodes about token transfer.
    *  @param _to address Address that receives tokens.
    *  @param _form address Address that sends tokens.
    *  @param _amount uint256 Amount of tokens to transfer.
    */
    event TokenTransfer(address _to, address _from, uint256 _amount);

    /*
    *  @dev Function to transfer tokens.
    *  @param _to address Address that receives tokens.
    *  @param _value uint256 Amount of tokens to transfer.
    */
    function transfer(address _to, uint256 _value) public{
        require(_to != 0);
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        TokenTransfer(_to, msg.sender, _value);
    }

    /*
    *  @dev Function to mint tokens.
    *  @param _amount uint256 Amount of tokens to mint.
    */
    function mintToken(uint256 _amount) public onlyOwner{
      require(balanceOf[msg.sender] < balanceOf[msg.sender] + _amount);
      balanceOf[msg.sender] += _amount;
      totalSupply += _amount;
      TokenTransfer(msg.sender, 0, _amount);
    }

    function buyToken() public payable{
      uint256 amount;
      amount = msg.value / buyPrice;
      require(balanceOf[this] > amount);
      require(balanceOf[msg.sender] < balanceOf[msg.sender] + amount);
      balanceOf[msg.sender] += amount;
      balanceOf[this] -= amount;
      TokenTransfer(msg.sender, this, amount);
    }

    function retrieveEther() public onlyOwner{
      if(!owner.send(this.balance)) revert();
    }
}
