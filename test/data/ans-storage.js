module.exports = Object.freeze({
  abi: [
    {
      "constant": false,
      "inputs": [],
      "name": "renounceOwnership",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "isOwner",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "name": "owner",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "name",
          "type": "bytes32"
        }
      ],
      "name": "assignName",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        },
        {
          "name": "limit",
          "type": "uint8"
        }
      ],
      "name": "setMinLimit",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "name",
          "type": "bytes32"
        }
      ],
      "name": "resolveName",
      "outputs": [
        {
          "name": "resolved",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "getMinLimit",
      "outputs": [
        {
          "name": "limit",
          "type": "uint8"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ],
  bytecode: '0x608060405234801561001057600080fd5b5060405160208061062f8339810180604052602081101561003057600080fd5b505160008054600160a060020a031916600160a060020a0380841691909117808355604051849391909216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0908290a35080600160a060020a03811615156100fa57604080517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601760248201527f52657175697265732076616c696420616464726573732e000000000000000000604482015290519081900360640190fd5b50506105248061010b6000396000f3fe608060405234801561001057600080fd5b50600436106100a5576000357c010000000000000000000000000000000000000000000000000000000090048063b3d4184a11610078578063b3d4184a14610130578063dd3072911461015f578063ead650541461017c578063f2fde38b14610199576100a5565b8063715018a6146100aa5780638da5cb5b146100b45780638f32d59b146100d8578063956794b1146100f4575b600080fd5b6100b26101bf565b005b6100bc61025e565b60408051600160a060020a039092168252519081900360200190f35b6100e061026d565b604080519115158252519081900360200190f35b61011a6004803603602081101561010a57600080fd5b5035600160a060020a031661027e565b6040805160ff9092168252519081900360200190f35b6100e06004803603604081101561014657600080fd5b508035600160a060020a0316906020013560ff1661029c565b6100e06004803603602081101561017557600080fd5b5035610316565b6100bc6004803603602081101561019257600080fd5b5035610394565b6100b2600480360360208110156101af57600080fd5b5035600160a060020a03166103af565b6101c761026d565b15156102075760405160e560020a62461bcd02815260040180806020018281038252602a8152602001806104cf602a913960400191505060405180910390fd5b60008054604051600160a060020a03909116907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0908390a36000805473ffffffffffffffffffffffffffffffffffffffff19169055565b600054600160a060020a031690565b600054600160a060020a0316331490565b600160a060020a031660009081526002602052604090205460ff1690565b60006102a661026d565b15156102e65760405160e560020a62461bcd02815260040180806020018281038252602a8152602001806104cf602a913960400191505060405180910390fd5b50600160a060020a0382166000908152600260205260409020805460ff831660ff19909116179055600192915050565b600061032061026d565b15156103605760405160e560020a62461bcd02815260040180806020018281038252602a8152602001806104cf602a913960400191505060405180910390fd5b506000818152600160208190526040909120805473ffffffffffffffffffffffffffffffffffffffff191633179055919050565b600090815260016020526040902054600160a060020a031690565b6103b761026d565b15156103f75760405160e560020a62461bcd02815260040180806020018281038252602a8152602001806104cf602a913960400191505060405180910390fd5b600160a060020a03811615156104415760405160e560020a62461bcd0281526004018080602001828103825260258152602001806104aa6025913960400191505060405180910390fd5b60008054604051600160a060020a03808516939216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a36000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a039290921691909117905556fe52657175697265732076616c6964206164647265737320666f72206e6577206f776e65722e4f776e6572206973206f6e6c7920616c6c6f77656420746f2063616c6c2074686973206d6574686f642ea165627a7a72305820823afd611bd036c2c28b57843f02174e77875d98ddb2b44548880958f5baf49d0029',
})
