const { assert } = require('chai')
const TimeMachine = require('sol-time-machine')
const sassert = require('sol-assert')

const getConstants = require('../constants')
const ANSStorage = require('../data/ans-storage')

const web3 = global.web3

contract('ANSStorage', (accounts) => {
  const { OWNER, ACCT1, ACCT2, INVALID_ADDR } = getConstants(accounts)
  const timeMachine = new TimeMachine(web3)
  
  let storage

  beforeEach(async () => {
    await timeMachine.snapshot

    storage = new web3.eth.Contract(ANSStorage.abi)
    storage = await storage.deploy({
      data: ANSStorage.bytecode,
      arguments: [OWNER],
    }).send({ from: OWNER, gas: 4712388 })
  })
  
  afterEach(async () => {
    await timeMachine.revert
  })

  describe('constructor', () => {
    it('sets the owner of the contract', async () => {
      assert.equal(await storage.methods.owner().call(), OWNER)
    })
  })

  describe('assignName', () => {
    it('assigns the name for the senders address', async () => {
      let name = web3.utils.fromAscii('hello')
      await storage.methods.assignName(name).send({ from: OWNER })
      assert.equal(await storage.methods.resolveName(name).call(), OWNER)

      name = web3.utils.fromAscii('world')
      await storage.methods.assignName(name).send({ from: OWNER })
      assert.equal(await storage.methods.resolveName(name).call(), OWNER)
    })
  })

  describe('setMinLimit', () => {
    it('sets the limit for the specified address', async () => {
      assert.equal(await storage.methods.owner().call(), OWNER)

      await storage.methods.setMinLimit(OWNER, 5).send({ from: OWNER })
      assert.equal(await storage.methods.getMinLimit(OWNER).call(), 5)

      await storage.methods.setMinLimit(OWNER, 10).send({ from: OWNER })
      assert.equal(await storage.methods.getMinLimit(OWNER).call(), 10)
    })

    it('throws if trying to call it from a non-owner', async () => {
      try {
        await storage.methods.setMinLimit(ACCT1, 5).send({ from: ACCT1 })
      } catch (err) {
        sassert.revert(err)
      }
    })
  })

  describe('resolveName', () => {
    it('returns the resolved address', async () => {
      let name = web3.utils.fromAscii('hello')
      await storage.methods.assignName(name).send({ from: OWNER })
      assert.equal(await storage.methods.resolveName(name).call(), OWNER)

      name = web3.utils.fromAscii('world')
      assert.equal(await storage.methods.resolveName(name).call(), INVALID_ADDR)
    })
  })

  describe('getMinLimit', () => {
    it('returns the min limit', async () => {
      await storage.methods.setMinLimit(ACCT1, 5).send({ from: OWNER })
      assert.equal(await storage.methods.getMinLimit(ACCT1).call(), 5)

      assert.equal(await storage.methods.getMinLimit(ACCT2).call(), 0)
    })
  })
})
