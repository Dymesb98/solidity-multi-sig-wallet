pragma solidity ^0.5.16;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        mapping(address => bool) isConfirmed;
        uint numConfirmations;
    }

    Transaction[] public transactions;

    modifier onlyOwner() {
        _;
    }

    /*
    Exercise
    1. Validate that the _owner is not empty
    2. Validate that _numConfirmationsRequired is greater than 0
    3. Validate that _numConfirmationsRequired is less than or equal to the number of _owners
    4. Set the state variables owners from the input _owners.
        - each owner should not be the zero address
        - validate that the owners are unique using the isOwner mapping
    5. Set the state variable numConfirmationsRequired from the input.
    */
    constructor(address[] memory _owners, uint _numConfirmationsRequired) public {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    /*
    Exercise
    1. Declare a payable fallback function
        - it should emit the Deposit event with
            - msg.sender
            - msg.value
            - current amount of ether in the contract (address(this).balance)
    */
    function () payable external {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    /* Exercise
    1. Complete the onlyOwner modifier defined above.
        - This modifier should require that msg.sender is an owner
    2. Inside submitTransaction, create a new Transaction struct from the inputs
       and append it the transactions array
        - executed should be initialized to false
        - numConfirmations should be initialized to 0
    3. Emit the SubmitTransaction event
        - txIndex should be the index of the newly created transaction
    */
    function submitTransaction(address _to, uint _value, bytes memory _data)
        public
        onlyOwner
    {

    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint _txIndex)
        public
        view
        returns (address to, uint value, bytes memory data, bool executed, uint numConfirmations)
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}
