var MySite = artifacts.require('MySite')

contract('MySite', (accounts) => {

    var dev1 = accounts[0]
    var dev2 = accounts[1]

    it('Developer 1 can request key', async() => {
        const mySite = await MySite.deployed()

        await mySite.addDetails('Mano', 'https://abc.com', 'abc@gmail.com', '12345', {from: dev1})
        var transCount = await mySite.transCount()

        assert.equal(transCount, 1, 'Invalid transaction count')
    })

    it('Developer 1 cannot request new key for the same site before the validation window ends', async() => {
        const mySite = await MySite.deployed()

        try {
            await mySite.addDetails('Mano', 'https://abc.com', 'abc@gmail.com', '12345', {from: dev1})
        } catch(error) {
            assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert This URL is currently hashed! -- Reason given: This URL is currently hashed!.')
        }

        var transCount = await mySite.transCount()
        assert.equal(transCount, 1, 'Invalid transaction count')
    })

    it('Developer 1 cannot request new key for a different site before the previous validation window ends', async() => {
        const mySite = await MySite.deployed()

        try {
            await mySite.addDetails('Mano', 'https://xyz.com', 'abc@gmail.com', '56789', {from: dev1})
        } catch(error) {
            assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert This address is already in a validation window! -- Reason given: This address is already in a validation window!.')
        }

        var transCount = await mySite.transCount()
        assert.equal(transCount, 1, 'Invalid transaction count')
    })

    it('Developer 2 cannot request a key for a the same site before its previous validation window ends', async() => {
        const mySite = await MySite.deployed()

        try {
            await mySite.addDetails('Lingam', 'https://abc.com', 'xyz@gmail.com', '12345', {from: dev2})
        } catch(error) {
            assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert This URL is currently hashed! -- Reason given: This URL is currently hashed!.')
        }

        var transCount = await mySite.transCount()
        assert.equal(transCount, 1, 'Invalid transaction count')
    })

    it('Developer 2 can request a key for a different site', async() => {
        const mySite = await MySite.deployed()

        await mySite.addDetails('Lingam', 'https://pqr.com', 'xyz@gmail.com', '11111', {from: dev2})

        var transCount = await mySite.transCount()

        assert.equal(transCount, 2, 'Invalid transaction count')
    })

    it('Developer 1 details are properly registered', async() => {
        const mySite = await MySite.deployed()

        var result = await mySite.getDevDetails({from: dev1})

        assert.equal(result[0], 'Mano')
        assert.equal(result[1], 'https://abc.com')
        assert.equal(result[2], 'abc@gmail.com')
    })

    it('Developer 2 details are properly registered', async() => {
        const mySite = await MySite.deployed()

        var result = await mySite.getDevDetails({from: dev2})

        assert.equal(result[0], 'Lingam')
        assert.equal(result[1], 'https://pqr.com')
        assert.equal(result[2], 'xyz@gmail.com')
    })

})