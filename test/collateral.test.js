const { expect } = require("chai");

describe("Collateral",  function() {
    let deployer, addr1, addr2, nft
    let feePercent = 10
    let URI = "Sample URI"
    beforeEach(async function () {
        // Get contract factories
        const Collateral = await ethers.getContractFactory("Collateral");

        [deployer, addr1, addr2] = await ethers.getSigners();

        nft = await Collateral.deploy();
    });

    describe("Collateral Deployment", function() {
        it("Should track the name and symbol on mint", async function() {
            expect(await nft.name()).to.equal("Collateral")
            expect(await nft.symbol()).to.equal("CLT")
        })
    });

    describe("Minting", function() {
        it("Should track the minted NFT", async function() {
            await nft.connect(addr1).mint(URI)
            expect(await nft.tokenCount()).to.equal(1)
            expect(await nft.balanceOf(addr1.address)).to.equal(1)
            expect(await nft.tokenURI(1)).to.equal("Sample URI")

            await nft.connect(addr2).mint(URI)
            expect(await nft.tokenCount()).to.equal(2)
            expect(await nft.balanceOf(addr2.address)).to.equal(1)
            expect(await nft.tokenURI(2)).to.equal("Sample URI")
        })
    });
});
