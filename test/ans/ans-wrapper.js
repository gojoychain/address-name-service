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

  beforeEach(async () => {
    await timeMachine.snapshot
    
    storage = await ANSStorage.deployed(OWNER, { from: OWNER, gas: MAX_GAS })
    storageAddr = storage.contract._address
    
    ansLib = await ANS.deployed({ from: OWNER, gas: MAX_GAS })
    ansLibAddr = ansLib.contract._address

    ansWrap = await ANSWrapper.deployed({ from: OWNER, gas: MAX_GAS })
    ansWrapAddr = ansWrap.contract._address

    console.log('storage', storageAddr)
    console.log('ansLib', ansLibAddr)
    console.log('ansWrap', ansWrapAddr)
  })
  
  afterEach(async () => {
    await timeMachine.revert
  })

  describe('assignName', () => {
    it('assigns the name', async () => {
      const name = 'a'
      const test = await ansWrap.contract.methods.test(name).call()
      console.log(test)

      // await ansWrap.contract.methods.assignName(ansLibAddr, storageAddr, name)
      //   .send({ from: OWNER, gas: 100000 })
      // assert.equal(
      //   await ansWrap.contract.methods.resolveName(ansLibAddr, storageAddr, name)
      //     .call({ from: OWNER }),
      //   ansWrapAddr,
      // )
    })
  })
})
