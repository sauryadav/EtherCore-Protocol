State variables
    address public owner;
    uint256 public totalDeposits;
    uint256 public contractBalance;
    
    Events
    event Deposit(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawal(address indexed user, uint256 amount, uint256 timestamp);
    event Transfer(address indexed from, address indexed to, uint256 amount, uint256 timestamp);
    
    Constructor
    constructor() {
        owner = msg.sender;
        totalDeposits = 0;
        contractBalance = 0;
    }
    
    /**
     * @dev Core Function 1: Deposit Ether into the protocol
     * Allows users to deposit ETH into their account
     */
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        
        userBalances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        contractBalance += msg.value;
        
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
    
    /**
     * @dev Core Function 2: Withdraw Ether from the protocol
     * Allows users to withdraw their deposited ETH
     * @param amount The amount of ETH to withdraw
     */
    function withdraw(uint256 amount) public hasSufficientBalance(amount) {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(contractBalance >= amount, "Insufficient contract balance");
        
        userBalances[msg.sender] -= amount;
        contractBalance -= amount;
        
        View functions
    
    /**
     * @dev Get the balance of a specific user
     * @param user The address of the user
     * @return The balance of the user
     */
    function getBalance(address user) public view returns (uint256) {
        return userBalances[user];
    }
    
    /**
     * @dev Get the caller's balance
     * @return The balance of the caller
     */
    function getMyBalance() public view returns (uint256) {
        return userBalances[msg.sender];
    }
    
    /**
     * @dev Get the total contract balance
     * @return The total ETH held in the contract
     */
    function getContractBalance() public view returns (uint256) {
        return contractBalance;
    }
    
    Fallback and receive functions
    receive() external payable {
        deposit();
    }
    
    fallback() external payable {
        deposit();
    }
}
// 
End
// 
