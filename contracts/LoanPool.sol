// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

/**
 * Loan Pool Contract will hold the collateral of borrowers and create the
 * loans. Will update state variables stored in contract to reflect these loans.
 **/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract LoanPool is ChainlinkClient {

    using Chainlink for Chainlink.Request;
    // Events for emitting when certain things happen
    event PostedLoan(address proposer, uint id);
    event CeaseLoan(address retractor, uint id);
    event AcceptedLoan(address borrower, address lender, uint amnt, uint id);
    event LoanPaid(address borrower, uint id);
    event LoanDefaulted(address borrower, address lender, uint id);
    event CollectionAdded(address collection);

    // State variables, mappings
    address private immutable owner;
    uint64  public loanId;
    uint32  public immutable feePercent;
    bytes32 private jobId = "6a92925dbb0e48e9b375b1deac4751c0";
    uint256 private fee = 0.1 * (10 ** 18);
    uint96 public currFloor;

    mapping(uint => Loan) pendingLoans;
    mapping(uint => Loan) activeLoans;

    struct Loan {
        IERC721 nft;
        bool paidOff;
        bool loanActive;
        address borrower;
        uint96 requestedAmount;
        address lender;
        uint96 toPay;
        uint64 timeStart;
        uint64 timeEnd;
        uint96 id;
        uint224 nftId;
        uint96 priceAtProposal;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner of the contract!");
        _;
    }

    constructor (uint32 _feePercent) {
        owner = msg.sender;
        feePercent = _feePercent;
        setChainlinkToken(0x01BE23585060835E02B77ef475b0Cc51aA1e0709);  // Rinkeby Link address
        setChainlinkOracle(0xF59646024204a733E1E4f66B303c9eF4f68324cC);  // Rinkeby test node oracle address
    }

    /***************** CHAINLINK FUNCTIONS  ******************/

    function requestFloorPrice(string calldata _slug) public payable {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        string memory url = string.concat("https://testnets-api.opensea.io/api/v1/collection/", _slug);
        req.add('get', url);
        req.add("path", 'collection,stats,floor_price');
        req.addInt("times", 10 ** 18);

        sendChainlinkRequest(req, fee);
    }

    function fulfill(bytes32 _requestId, uint96 _price) public recordChainlinkFulfillment(_requestId) {
        currFloor = _price;
    }

    function _fee() public view returns (uint) {
        return feePercent;
    }

    function _owner() public view returns (address) {
        return owner;
    }

    function accessPending(uint _index) public view returns (Loan memory) {
        return pendingLoans[_index];
    }

    function accessActive(uint _index) public view returns (Loan memory) {
        return activeLoans[_index];
    }

    function withdraw() external onlyOwner() {
        payable(owner).transfer(address(this).balance);
    }

    // To check if the loan corresponding to the id passed in is a valid active loan
    modifier validActiveLoan(uint96 _id) {
        require(activeLoans[_id].id == _id, "Invalid loan!");
        _;
    }
    // This function is for lenders to call if the loan period is over
    function liquidateLoan(uint96 _id) internal {
        Loan memory liqLoan = activeLoans[_id];
        liqLoan.nft.transferFrom(
            address(this),
            liqLoan.lender,
            liqLoan.nftId
        );

        emit LoanDefaulted(
            liqLoan.borrower,
            liqLoan.lender,
            liqLoan.nftId
        );
    }


    /**************************  BORROWER FUNCTIONS  **************************/

    /**
     * Small Loan Borrower Contract will allow users to propose a loan,
     * retract a proposed loan that hasn't yet been accepted, and to
     * pay off a loan in full.
     **/

     function propose(
        IERC721 _nft,
        uint224 _nftId,
        uint96 _reqAmnt,
        uint96 _toPay,
        uint64 _duration,
        string calldata _slug
    ) public {
        // can remove this requirement; people might let users
        require(_toPay > _reqAmnt, "Cannot request more than you pay!");
        require(
            _nft.getApproved(_nftId) == address(this),
            "Transfer not approved!"
        );
        requestFloorPrice(_slug);
        require(_reqAmnt < (currFloor >> 1));  // Call to Chainlink to verify that the requested amount is less than half the floor price
        _nft.transferFrom(msg.sender, address(this), _nftId);
        Loan memory newLoan = Loan({
            borrower:        msg.sender,
            lender:          address(0),
            nft:             _nft,
            nftId:           _nftId,
            requestedAmount: _reqAmnt,
            toPay:           _toPay,
            timeStart:       0,
            timeEnd:         _duration * (1 days),
            id:              ++loanId,
            paidOff:         false,
            loanActive:      false,
            priceAtProposal: currFloor
        });

        pendingLoans[loanId] = newLoan;

        emit PostedLoan(msg.sender, loanId);
    }

    // Borrower should be able to retract a proposed loan before it's accepted
    function retract(uint96 _id) external {
        require(activeLoans[_id].id != _id, "Loan is already active!");
        require(
            pendingLoans[_id].borrower == msg.sender,
            "Can only retract your loans!"
        );

        pendingLoans[_id].nft.transferFrom(
            address(this),
            pendingLoans[_id].borrower,
            pendingLoans[_id].nftId
        );
        pendingLoans[_id].borrower = address(0);

        emit CeaseLoan(msg.sender, _id);
    }

    // Borrower should be able to pay off loan
    function payInFull(uint96 _id) external payable validActiveLoan(_id) {
        require(
            activeLoans[_id].borrower == msg.sender,
            "Can only pay off your own loans!"
        );
        require(msg.value >= activeLoans[_id].toPay, "Must pay loan in full!");

        uint profit = activeLoans[_id].toPay - activeLoans[_id].requestedAmount;
        uint poolFee = (profit * feePercent) / 100;

        payable(activeLoans[_id].lender).transfer(
            activeLoans[_id].toPay - poolFee
        );

        activeLoans[_id].toPay = 0;
        activeLoans[_id].paidOff = true;
        activeLoans[_id].nft.transferFrom(
            address(this),
            activeLoans[_id].borrower,
            activeLoans[_id].nftId
        );

        emit LoanPaid(msg.sender, _id);
    }



    /***************************  LENDER FUNCTIONS  ***************************/

    /**
     * Small Loan Lender will allow users to accept a proposed loan
     * and liquidate defaulted loans.
     **/

    // Lender should be able to lend to a borrower
    function acceptLoan(uint96 _loanId) external payable {
        require(
            activeLoans[_loanId].id != _loanId,
            "Loan has already been accepted!"
        );

        Loan memory accepting = pendingLoans[_loanId];

        require(
            accepting.borrower != address(0),
            "Loan has been retracted!"
        );

        require(
            msg.value >= accepting.requestedAmount,
            "You need to loan out the full amount!"
        );

        payable(accepting.borrower).transfer(accepting.requestedAmount);
        activeLoans[_loanId] = Loan({
            borrower:        accepting.borrower,
            lender:          msg.sender,
            nft:             accepting.nft,
            nftId:           accepting.nftId,
            requestedAmount: accepting.requestedAmount,
            toPay:           accepting.toPay,
            timeStart:       accepting.timeStart + uint64(block.timestamp),
            timeEnd:         accepting.timeEnd + uint64(block.timestamp),
            id:              _loanId,
            paidOff:         false,
            loanActive:      true,
            priceAtProposal: accepting.priceAtProposal
        });

        delete pendingLoans[_loanId];

        emit AcceptedLoan(
            accepting.borrower,
            msg.sender,
            accepting.requestedAmount,
            _loanId
        );
    }

    // Lender should be able to liquidate defaulted loans
    function liquidate(uint96 _id, string calldata _slug) external validActiveLoan(_id) {
        Loan memory loan = activeLoans[_id];

        requestFloorPrice(_slug);  // Call to Chainlink oracle to see if floor price has fallen enough

        require(
            block.timestamp > loan.timeEnd && loan.loanActive ||
            (currFloor << 1) < loan.priceAtProposal,
            "Loan period still active!"
        );

        require(msg.sender == loan.lender, "Not lender");

        require(
            !loan.paidOff,
            "Loan was paid off!"
        );

        activeLoans[_id].nft.transferFrom(
            address(this),
            loan.lender,
            loan.nftId
        );

        activeLoans[_id].loanActive = false;

        // _safeMint(activeLoans[_id].borrower, ++defaultedLoanCount);

        emit LoanDefaulted(
            loan.borrower,
            loan.lender,
            loan.nftId
        );
    }

    /****************************  NFT FUNCTIONS  ****************************/

    // function transferFrom(
    //     address _from,
    //     address _to,
    //     uint _tokenId
    // ) public override {
    //     require(msg.sender == owner, "NFT non-transferrable");

    //     transfer(_from, _to, _tokenId);
    // }
}
