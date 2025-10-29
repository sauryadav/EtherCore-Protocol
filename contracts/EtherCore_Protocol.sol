// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title EtherCore Protocol
 * @dev A decentralized protocol for secure value storage and transfer
 * @author EtherCore Team
 */
contract Project {
    
    // State variables
    address public owner;
    uint256 public totalDeposits;
    uint256 public contractBalance;
    
    // Mapping to track user deposits
    mapping(address => uint256) public userBalances;
    
    // Events
    event Deposit(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawal(address indexed user, uint256 amount, uint256 timestamp);
    event Transfer(address indexed from, address indexed to, uint256 amount, uint256 timestamp);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier hasSufficientBalance(uint256 amount) {
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        _;
    }
    
    // Constructor
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
        
        // Transfer ETH to user
        payable(msg.sender).transfer(amount);
        
        emit Withdrawal(msg.sender, amount, block.timestamp);
    }
    
    /**
     * @dev Core Function 3: Transfer funds between users
     * Allows users to transfer their balance to another user within the protocol
     * @param recipient The address to receive the funds
     * @param amount The amount to transfer
     */
    function transferFunds(address recipient, uint256 amount) public hasSufficientBalance(amount) {
        require(amount > 0, "Transfer amount must be greater than zero");
        require(recipient != address(0), "Invalid recipient address");
        require(recipient != msg.sender, "Cannot transfer to yourself");
        
        userBalances[msg.sender] -= amount;
        userBalances[recipient] += amount;
        
        emit Transfer(msg.sender, recipient, amount, block.timestamp);
    }
    
    // View functions
    
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
    
    // Owner functions
    
    /**
     * @dev Emergency withdraw for owner (safety feature)
     * Only to be used in case of critical issues
     */
    function emergencyWithdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }
    
    // Fallback and receive functions
    receive() external payable {
        deposit();
    }
    
    fallback() external payable {
        deposit();
    }
}