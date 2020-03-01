pragma solidity 0.5.0;
// should extend ERC20 token?
contract Unifi {
    // Minimum topup is 10 MB = 10,000,000,000,000 wei
    uint256 constant decimals = 18;
    uint256 eth = 10 ** decimals;
    uint constant minimum_topup = 10_000_000_000_000 wei;
    uint8 base_rating = 3;
    struct User {
        bool is_connected;  // to the wifi?
        bool is_registered; // have he ever used Uni-Fi
        uint256 balance;
    }

    struct Host {
        uint256 balance;
        uint256 longitude;
        uint256 latitude;
        uint256 users_connected;
        uint256 base_fee;
        string ssid;
        string mac_address;
        uint8[5] rating;
    }
    mapping(address => Host) host_array;
    mapping(address => User) user_array;
    mapping(address => uint) pendingWithdrawals;
    constructor() public {
       // set owner
    }
    modifier isConnected(address user) {
        require(user_array[user].is_connected == true);
        _;
    }
    modifier isNotConnected(address user) {
        require(user_array[user].is_connected == false);
        _;
    }
    function registerHost(uint256 _longitude,
        uint256 _latitude,
        uint256 _base_fee,
        string memory _ssid,
        string memory _mac_address ) public {
        host_array[msg.sender].base_fee = _base_fee;
        host_array[msg.sender].longitude = _longitude;
        host_array[msg.sender].latitude = _latitude;
        host_array[msg.sender].ssid = _ssid;
        host_array[msg.sender].mac_address = _mac_address;
        host_array[msg.sender].balance = 0;
    }
    function registerUser() private isNotConnected {
        user_array[msg.sender] = User({
            is_connected: false,
            is_registered: true,
            balance: 0
        });
    }
    function repHost(address _host, uint8 _rep) internal {
        host_array[_host].rating[_rep] += 1;
    }
    function login() public isNotConnected {
        if ( user_array[msg.sender].is_registered == false ) {
            registerUser();
        }
        // here we login
        user_array[msg.sender].is_connected = true;
    }
    function logout(address user, uint charge) public isConnected(user) {
        // subtract the charge
        user_array[user].balance -= charge;
        withdrawUser();
        //address(this).transfer(due_to_contract);
        // user.transfer(due_to_user);
        user_array[user].is_connected = false;
    }
    function deposit() public payable {
        user_array[msg.sender].balance += msg.value;
    }
    function withdrawHost() public {
        // subtract user usage from host balance
        uint amount = pendingWithdrawals[msg.sender];
        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
    function withdrawUser() public {
        // subtract user usage from user balance
        uint amount = pendingWithdrawals[msg.sender];
        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        msg.sender.transfer(amount);
        pendingWithdrawals[msg.sender] = 0;
    }
    // /// Handle ethers received by the contract
    // receive() external payable {
    // }
    // /// Handle undefined function calls
    // fallback() external {
    //     revert();
    // }
}