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
    console.log('owner', OWNER)
  })
  
  describe('assignName', () => {
    it('assigns the name', async () => {
      const name = '12345678'
      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      assert.equal(await wrapMethods.resolveName(storageAddr, name).call(), ansWrapAddr)
    })

    // TODO: expected failing. need to figure out delegatecall with wrapper contract.
    it('uses the assigned min limit', async () => {
      await wrapMethods.setMinLimit(ansLibAddr, storageAddr, ansWrapAddr, 1).send({ from: OWNER, gas: 100000 })

      const name = '1'
      assert.equal(name.length, 1)

      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      assert.equal(await wrapMethods.resolveName(storageAddr, name).call(), ansWrapAddr)
    })

    it('converts the name to lowercase', async () => {
      const name = 'ABCDEFGH'
      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      assert.equal(await wrapMethods.resolveName(storageAddr, name).call(), ansWrapAddr)
    })

    it('throws if storageAddress is not valid', async () => {
      const name = '1234567'
      assert.equal(name.length, 7)

      try {
        await wrapMethods.assignName(INVALID_ADDR, name).send({ from: OWNER, gas: 100000 })
      } catch (err) {
        sassert.revert(err)
      }
    })
    
    it('throws if the name is too short', async () => {
      const name = '1234567'
      assert.equal(name.length, 7)

      try {
        await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the name is too long', async () => {
      const name = '123456789012345678901'
      assert.equal(name.length, 21)

      try {
        await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the name is a hex string', async () => {
      const name = '0x1234567890'

      try {
        await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the name is taken', async () => {
      const name = '1234567890'

      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      assert.equal(await wrapMethods.resolveName(storageAddr, name).call(), ansWrapAddr)

      try {
        await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      } catch (err) {
        sassert.revert(err)
      }
    })
  })

  describe('resolveName', () => {
    it('resolves the name', async () => {
      const name = '12345678'
      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      assert.equal(await wrapMethods.resolveName(storageAddr, name).call(), ansWrapAddr)
    })

    it('converts the name to lowercase', async () => {
      let name = 'abcdefgh'
      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })

      name = 'ABCDEFGH'
      assert.equal(await wrapMethods.resolveName(storageAddr, name).call(), ansWrapAddr)
    })

    it('throws if storageAddress is not valid', async () => {
      const name = '12345678'
      await wrapMethods.assignName(storageAddr, name).send({ from: OWNER, gas: 100000 })
      try {
        await wrapMethods.resolveName(INVALID_ADDR, name).call()
      } catch (err) {
        sassert.revert(err)
      }
    })
  })
})
