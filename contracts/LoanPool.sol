// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * Loan Pool Contract will hold the collateral of borrowers and create the
 * loans. Will update state variables stored in contract to reflect these loans.
 **/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LoanPool {

    // Events for emitting when certain things happen
    event PostedLoan(address proposer, uint id);
    event CeaseLoan(address retractor, uint id);
    event AcceptedLoan(address borrower, address lender, uint amnt, uint id);
    event LoanPaid(address borrower, uint id);
    event LoanDefaulted(address borrower, address lender, uint id);
    event CollectionAdded(address collection);

    // State variables, mappings
    address private immutable owner;
    uint96  public loanId;
    uint256 public immutable feePercent;

    mapping(uint => Loan) pendingLoans;
    mapping(uint => Loan) activeLoans;

    struct Loan {
        IERC721 nft;
        address borrower;
        uint96 requestedAmount;
        address lender;
        uint96 toPay;
        uint64 timeStart;
        uint64 timeEnd;
        uint96 id;
        uint256 nftId;
        bool paidOff;
        bool loanActive;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner of the contract!");
        _;
    }

    constructor (uint _feePercent) {
        owner = msg.sender;
        feePercent = _feePercent;
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
        uint96 _nftId,
        uint96 _reqAmnt,
        uint96 _toPay,
        uint64 _duration
    ) public {
        require(_toPay > _reqAmnt, "Cannot request more than you pay!");
        require(
            _nft.getApproved(_nftId) == address(this),
            "Transfer not approved!"
        );
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
            loanActive:      false
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
            loanActive:      true
        });

        emit AcceptedLoan(
            accepting.borrower,
            msg.sender,
            accepting.requestedAmount,
            _loanId
        );
    }

    // Lender should be able to liquidate defaulted loans
    function liquidate(uint96 _id) external validActiveLoan(_id) {
        Loan memory loan = activeLoans[_id];
        require(
            block.timestamp > loan.timeEnd && loan.loanActive,
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
