const { expect } = require("chai");

describe("SmallLoanPool",  function() {
    let deployer, addr1, addr2, loanPool, nft
    let URI = "Sample URI"
    beforeEach(async function () {
        // Get contract factories
        const LoanPool = await ethers.getContractFactory("SmallLoan");
        const Collateral = await ethers.getContractFactory("Collateral");

        [deployer, addr1, addr2] = await ethers.getSigners();

        loanPool = await LoanPool.deploy(10);
        nft = await Collateral.deploy();
    });

    describe("Borrower-Side Tests", function() {
        beforeEach(async function () {
            await nft.connect(addr1).mint(URI);
            await nft.connect(addr1).approve(loanPool.address, 1);
        })

        it("Should allow addr1 to list an NFT", async function() {
            expect(await loanPool.connect(addr1).propose(nft.address, 1, 10000, 12000, 1))
            .to.emit(loanPool, "PostedLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)
        })

        it("Should allow addr1 to retract their proposed loan", async function() {
            expect(await loanPool.connect(addr1).propose(nft.address, 1, 10000, 12000, 1))
            .to.emit(loanPool, "PostedLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)

            expect(await loanPool.connect(addr1).retract(1))
            .to.emit(loanPool, "CeaseLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(addr1.address)
        })

        it("Should allow addr1 to fully repay their loan", async function() {
            expect(await loanPool.connect(addr1).propose(nft.address, 1, 10000, 12000, 1))
            .to.emit(loanPool, "PostedLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)

            // Need to make sure that the event logs the right data
            expect(await loanPool.connect(addr2).acceptLoan(1, { value: 10000 }))
            .to.emit(loanPool, "AcceptedLoan")
            .withArgs(addr1.address, addr2.address, 10000, 1)

            expect(await loanPool.connect(addr1).payInFull(1, { value: 12000 }))
            .to.emit(loanPool, "LoanPaid")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(addr1.address)
        })
    });

    describe("Lender-Side Tests", async function() {
        beforeEach(async function () {
            await nft.connect(addr1).mint(URI);
            await nft.connect(addr1).approve(loanPool.address, 1);
        })

        it("Should allow addr2 to accept a loan", async function() {
            expect(await loanPool.connect(addr1).propose(nft.address, 1, 10000, 12000, 1))
            .to.emit(loanPool, "PostedLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)

            // Need to make sure that the event logs the right data
            expect(await loanPool.connect(addr2).acceptLoan(1, { value: 10000 }))
            .to.emit(loanPool, "AcceptedLoan")
            .withArgs(addr1.address, addr2.address, 10000, 1)
        })

        it("Should see an increase in balance of lender after payout", async function() {
            const addr1InitBal = await addr1.getBalance();
            const addr2InitBal = await addr2.getBalance();

            expect(await loanPool.connect(addr1).propose(nft.address, 1, 100000000, 120000000, 1))
            .to.emit(loanPool, "PostedLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)

            // Need to make sure that the event logs the right data
            expect(await loanPool.connect(addr2).acceptLoan(1, { value: 100000000 }))
            .to.emit(loanPool, "AcceptedLoan")
            .withArgs(addr1.address, addr2.address, 10000, 1)

            expect(await loanPool.connect(addr1).payInFull(1, { value: 120000000 }))
            .to.emit(loanPool, "LoanPaid")
            .withArgs(addr1.address, 1)

            expect(addr1InitBal > await addr1.getBalance())
            expect(await addr2.getBalance() > addr2InitBal)
        })

        it("Should allow the lender to liquidate the borrower", async function() {
            expect(await loanPool.connect(addr1).propose(nft.address, 1, 10000, 12000, 1))
            .to.emit(loanPool, "PostedLoan")
            .withArgs(addr1.address, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)

            // Need to make sure that the event logs the right data
            expect(await loanPool.connect(addr2).acceptLoan(1, { value: 10000 }))
            .to.emit(loanPool, "AcceptedLoan")
            .withArgs(addr1.address, addr2.address, 10000, 1)

            expect(await nft.ownerOf(1)).to.equal(loanPool.address)

            expect(await loanPool.connect(addr2).liquidate(1))
            .to.emit(loanPool, "LoanDefaulted")

            expect(await nft.ownerOf(1)).to.equal(addr2.address)
        })
    })
});
