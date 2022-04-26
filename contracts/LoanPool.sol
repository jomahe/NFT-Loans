// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * Small Loan Pool Contract will hold the Ether of lenders and create the
 * actual loans. Will update state variables stored in LoanAggregator contract
 * to reflect these loans.
 **/

import "./NFT.sol";

contract SmallLoan is ERC721 {

    // Events for emitting when certain things happen
    event PostedLoan(address proposer, uint id);
    event CeaseLoan(address retractor, uint id);
    event AcceptedLoan(address borrower, address lender, uint amnt, uint id);
    event LoanPaid(address borrower, uint id);
    event LoanDefaulted(address borrower, address lender, uint id);
    event CollectionAdded(address collection);

    // State variables, mappings
    address private immutable owner;
    uint96  public smallLoanId;
    uint256 public immutable feePercent;
    // uint public defaultedLoanCount;

    mapping(uint => Loan) idToSmallLoan;
    mapping(uint => Loan) pendingLoans;
    mapping(uint => Loan) activeLoans;

    struct Loan {
        IERC721 nft;
        address borrower; // 20/32
        address lender;
        uint256 nftId;
        uint256 requestedAmount;
        uint256 toPay;
        uint256 timeStart;
        uint256 timeEnd;
        uint256 id;
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

    function withdraw() external onlyOwner() {
        payable(owner).transfer(address(this).balance);
    }

    // To check if the loan corresponding to the id passed in is a valid active loan
    modifier validActiveLoan(uint _id) {
        require(activeLoans[_id].id == _id, "Invalid loan!");
        _;
    }
    // This function is for lenders to call if the loan period is over
    function liquidateLoan(uint _id) internal {
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
}