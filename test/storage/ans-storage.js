const { assert } = require('chai')
const TimeMachine = require('sol-time-machine')

const getConstants = require('../constants')
const ANSStorage = require('../data/ans-storage')

const web3 = global.web3

contract('ANSStorage', (accounts) => {
  const { OWNER } = getConstants(accounts)
  const timeMachine = new TimeMachine(web3)
  
  let contract

  beforeEach(async () => {
    await timeMachine.snapshot

    contract = new web3.eth.Contract(ANSStorage.abi)
    contract = await contract.deploy({
      data: ANSStorage.bytecode,
      arguments: [OWNER],
    }).send({ from: OWNER, gas: 4712388 })
  })
  
  afterEach(async () => {
    await timeMachine.revert
  })

  describe('constructor', async () => {
    it('sets the owner of the contract', async () => {
      assert.equal(await contract.methods.owner().call(), OWNER)
    })
  })
})
