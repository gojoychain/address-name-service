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
  
  let storage
  let storageAddr
  let ansLib
  let ansLibAddr
  let ansWrap

  beforeEach(async () => {
    await timeMachine.snapshot
    
    storage = await ANSStorage.deployed(OWNER, { from: OWNER, gas: MAX_GAS })
    storageAddr = storage.contract._address
    
    ansLib = await ANS.deployed({ from: OWNER, gas: MAX_GAS })
    ansLibAddr = ansLib.contract._address

    ansWrap = await ANSWrapper.deployed({ from: OWNER, gas: MAX_GAS })
  })
  
  afterEach(async () => {
    await timeMachine.revert
  })

  describe('assignName', () => {
    it.only('throws if the name is not longer than the min limit', async () => {
      console.log(storageAddr)
      console.log(ansLibAddr)
      console.log(ansWrap)
      const name = web3.utils.asciiToHex('a')
      console.log(name)
      // try {
        await ansWrap.contract.methods.assignName(ansLibAddr, storageAddr, name).send({ from: ACCT1, gas: 2000000 })
      // } catch (err) {
        // sassert.revert(err)
      // }
    })
  })
})
