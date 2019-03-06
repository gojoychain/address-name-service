const { assert } = require('chai')
const TimeMachine = require('sol-time-machine')
const sassert = require('sol-assert')

const getConstants = require('../constants')

const ANSStorage = artifacts.require('ANSStorage')
const ANS = artifacts.require('ANS')
const ANSWrapper = artifacts.require('ANSWrapper')

const web3 = global.web3

contract('ANSWrapper', (accounts) => {
  const { OWNER, ACCT1, ACCT2, INVALID_ADDR, MAX_GAS } = getConstants(accounts)
  const timeMachine = new TimeMachine(web3)
  
  let storage, storageAddr
  let ansLib, ansLibAddr
  let ansWrap, ansWrapAddr
  let wrapMethods

  beforeEach(timeMachine.snapshot)
  afterEach(timeMachine.revert)

  beforeEach(async () => {
    storage = await ANSStorage.deployed(OWNER, { from: OWNER, gas: MAX_GAS })
    storageAddr = storage.contract._address
    
    ansLib = await ANS.deployed({ from: OWNER, gas: MAX_GAS })
    ansLibAddr = ansLib.contract._address

    ansWrap = await ANSWrapper.deployed({ from: OWNER, gas: MAX_GAS })
    ansWrapAddr = ansWrap.contract._address

    wrapMethods = ansWrap.contract.methods

    console.log('storage', storageAddr)
    console.log('ansLib', ansLibAddr)
    console.log('ansWrap', ansWrapAddr)
  })
  
  describe.only('assignName', () => {
    it('assigns the name', async () => {
      const name = '12345678'
      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      assert.equal(
        await wrapMethods.resolveName(storageAddr, name).call({ from: OWNER }),
        ansWrapAddr,
      )
    })
  })
})
