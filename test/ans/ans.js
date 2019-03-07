const { assert } = require('chai')
const TimeMachine = require('sol-time-machine')
const sassert = require('sol-assert')

const getConstants = require('../constants')

const ANSStorage = artifacts.require('ANSStorage')
const ANS = artifacts.require('ANS')

const web3 = global.web3

contract('ANS', (accounts) => {
  const { OWNER, ACCT1, INVALID_ADDR, MAX_GAS } = getConstants(accounts)
  const timeMachine = new TimeMachine(web3)
  
  let ans, ansAddr
  let storage, storageAddr
  let ansMethods

  beforeEach(timeMachine.snapshot)
  afterEach(timeMachine.revert)

  beforeEach(async () => {
    ans = await ANS.new(OWNER, { from: OWNER, gas: MAX_GAS })
    ansAddr = ans.contract._address
    ansMethods = ans.contract.methods

    storage = await ANSStorage.new(ansAddr, { from: OWNER, gas: MAX_GAS })
    storageAddr = storage.contract._address

    await ansMethods.setStorageAddress(storageAddr).send({ from: OWNER })
  })

  describe('constructor', () => {
    it('sets the owner of the contract', async () => {
      assert.equal(await ansMethods.owner().call(), OWNER)
    })

    it('throws if the owner address is not valid', async () => {
      try {
        await ANS.new(INVALID_ADDR, { from: OWNER, gas: MAX_GAS })
      } catch (err) {
        sassert.revert(err)
      }
    })
  })

  describe('setStorageAddress', () => {
    beforeEach(async () => {
      ans = await ANS.new(OWNER, { from: OWNER, gas: MAX_GAS })
      ansMethods = ans.contract.methods
    })

    it('sets the storage address', async () => {
      const name = 'abc'
      try {
        await ansMethods.resolveName(name).call()
      } catch (err) {
        sassert.revert(err)
      }

      assert.equal(await ansMethods.owner().call(), OWNER)
      await ansMethods.setStorageAddress(storageAddr).send({ from: OWNER })

      assert.equal(await ansMethods.resolveName(name).call(), INVALID_ADDR)
    })

    it('throws if trying to call it from a non-owner', async () => {
      assert.notEqual(await ansMethods.owner().call(), ACCT1)

      try {
        await ansMethods.setStorageAddress(storageAddr).send({ from: ACCT1 })
      } catch (err) {
        sassert.revert(err, 'Owner is only allowed to call this method.')
      }
    })

    it('throws if the storage address is not valid', async () => {
      try {
        await ansMethods.setStorageAddress(INVALID_ADDR).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the storage address is already set', async () => {
      await ansMethods.setStorageAddress(storageAddr).send({ from: OWNER })

      try {
        await ansMethods.setStorageAddress(storageAddr).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err)
      }
    })
  })
  
  describe('assignName', () => {
    it('assigns the name', async () => {
      const name = '12345678'
      await ansMethods.assignName(name).send({ from: OWNER })
      assert.equal(await ansMethods.resolveName(name).call(), OWNER)
    })

    it('converts the name to lowercase', async () => {
      const name = 'ABCDEFGH'
      await ansMethods.assignName(name).send({ from: OWNER })
      assert.equal(await ansMethods.resolveName(name).call(), OWNER)
    })

    it('throws if storage address is not set', async () => {
      ans = await ANS.new(OWNER, { from: OWNER, gas: MAX_GAS })
      ansMethods = ans.contract.methods

      const name = '12345678'
      try {
        await ansMethods.assignName(name).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err)
      }
    })
    
    it('throws if the name is too short', async () => {
      const name = '1234567'
      assert.equal(name.length, 7)

      try {
        await ansMethods.assignName(name).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the name is too long', async () => {
      const name = '123456789012345678901'
      assert.equal(name.length, 21)

      try {
        await ansMethods.assignName(name).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the name is a hex string', async () => {
      const name = '0x1234567890'

      try {
        await ansMethods.assignName(name).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err)
      }
    })

    it('throws if the name is taken', async () => {
      const name = '1234567890'

      await ansMethods.assignName(name).send({ from: OWNER })
      assert.equal(await ansMethods.resolveName(name).call(), OWNER)

      try {
        await ansMethods.assignName(name).send({ from: ACCT1 })
      } catch (err) {
        sassert.revert(err)
      }
    })
  })
  
  describe('setMinLimit', () => {
    // TODO: expected fail. assignName after setMinLimit not getting the set limit.
    // something with msg.sender calling from ANSWrapper is not same address.
    it('sets the name min limit of an address', async () => {
      assert.equal(await ansMethods.owner().call(), OWNER)

      const limit = 1
      await ansMethods.setMinLimit(OWNER, limit).send({ from: OWNER })
      assert.equal(await ansMethods.getMinLimit(OWNER).call(), limit)

      const name = '1'
      assert.equal(name.length, limit)

      await timeMachine.mine(1)
      await ansMethods.assignName(name).send({ from: OWNER })
      assert.equal(await ansMethods.resolveName(name).call(), OWNER)
    })

    it('throws if trying to call it from a non-owner', async () => {
      assert.notEqual(await ansMethods.owner().call(), ACCT1)

      try {
        await ansMethods.setMinLimit(OWNER, 1).send({ from: ACCT1 })
      } catch (err) {
        sassert.revert(err, 'Owner is only allowed to call this method.')
      }
    })

    it('throws if storage address is not set', async () => {
      ans = await ANS.new(OWNER, { from: OWNER, gas: MAX_GAS })
      ansMethods = ans.contract.methods

      try {
        await ansMethods.setMinLimit(OWNER, 1).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err, 'Storage address has not be set.')
      }
    })

    it('throws if the minLimit is not within the allowable range', async () => {
      try {
        await ansMethods.setMinLimit(OWNER, 0).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err, 'minLength must be between 1 and 8.')
      }

      try {
        await ansMethods.setMinLimit(OWNER, 9).send({ from: OWNER })
      } catch (err) {
        sassert.revert(err, 'minLength must be between 1 and 8.')
      }
    })
  })

  describe('resolveName', () => {
    it('resolves the name', async () => {
      const name = '12345678'
      await ansMethods.assignName(storageAddr, name)
        .send({ from: OWNER, gas: 100000 })
      assert.equal(
        await ansMethods.resolveName(storageAddr, name).call(), 
        ansWrapAddr,
      )
    })

    it('converts the name to lowercase', async () => {
      let name = 'abcdefgh'
      await ansMethods.assignName(storageAddr, name)
        .send({ from: OWNER, gas: 100000 })

      name = 'ABCDEFGH'
      assert.equal(
        await ansMethods.resolveName(storageAddr, name).call(),
        ansWrapAddr,
      )
    })

    it('throws if storageAddress is not valid', async () => {
      const name = '12345678'
      await ansMethods.assignName(storageAddr, name)
        .send({ from: OWNER, gas: 100000 })
      try {
        await ansMethods.resolveName(INVALID_ADDR, name).call()
      } catch (err) {
        sassert.revert(err)
      }
    })
  })
})
