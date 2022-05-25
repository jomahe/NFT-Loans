import { ethers } from "ethers"

export const loanPoolAddr = "0x77fDb6c68e5896F67C658DF02FB8637a4Aa0aeef"
export const loanPoolABI = `[{"inputs":[{"internalType":"uint256","name":"_feePercent","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"borrower","type":"address"},{"indexed":false,"internalType":"address","name":"lender","type":"address"},{"indexed":false,"internalType":"uint256","name":"amnt","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"}],"name":"AcceptedLoan","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"retractor","type":"address"},{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"}],"name":"CeaseLoan","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"collection","type":"address"}],"name":"CollectionAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"borrower","type":"address"},{"indexed":false,"internalType":"address","name":"lender","type":"address"},{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"}],"name":"LoanDefaulted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"borrower","type":"address"},{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"}],"name":"LoanPaid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"proposer","type":"address"},{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"}],"name":"PostedLoan","type":"event"},{"inputs":[],"name":"_fee","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"_owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint96","name":"_loanId","type":"uint96"}],"name":"acceptLoan","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_index","type":"uint256"}],"name":"accessActive","outputs":[{"components":[{"internalType":"contract IERC721","name":"nft","type":"address"},{"internalType":"address","name":"borrower","type":"address"},{"internalType":"uint96","name":"requestedAmount","type":"uint96"},{"internalType":"address","name":"lender","type":"address"},{"internalType":"uint96","name":"toPay","type":"uint96"},{"internalType":"uint64","name":"timeStart","type":"uint64"},{"internalType":"uint64","name":"timeEnd","type":"uint64"},{"internalType":"uint96","name":"id","type":"uint96"},{"internalType":"uint256","name":"nftId","type":"uint256"},{"internalType":"bool","name":"paidOff","type":"bool"},{"internalType":"bool","name":"loanActive","type":"bool"}],"internalType":"struct LoanPool.Loan","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_index","type":"uint256"}],"name":"accessPending","outputs":[{"components":[{"internalType":"contract IERC721","name":"nft","type":"address"},{"internalType":"address","name":"borrower","type":"address"},{"internalType":"uint96","name":"requestedAmount","type":"uint96"},{"internalType":"address","name":"lender","type":"address"},{"internalType":"uint96","name":"toPay","type":"uint96"},{"internalType":"uint64","name":"timeStart","type":"uint64"},{"internalType":"uint64","name":"timeEnd","type":"uint64"},{"internalType":"uint96","name":"id","type":"uint96"},{"internalType":"uint256","name":"nftId","type":"uint256"},{"internalType":"bool","name":"paidOff","type":"bool"},{"internalType":"bool","name":"loanActive","type":"bool"}],"internalType":"struct LoanPool.Loan","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"feePercent","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint96","name":"_id","type":"uint96"}],"name":"liquidate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"loanId","outputs":[{"internalType":"uint96","name":"","type":"uint96"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint96","name":"_id","type":"uint96"}],"name":"payInFull","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"contract IERC721","name":"_nft","type":"address"},{"internalType":"uint256","name":"_nftId","type":"uint256"},{"internalType":"uint96","name":"_reqAmnt","type":"uint96"},{"internalType":"uint96","name":"_toPay","type":"uint96"},{"internalType":"uint64","name":"_duration","type":"uint64"}],"name":"propose","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint96","name":"_id","type":"uint96"}],"name":"retract","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"}]`

export const useLoanPoolContract = () => {
    const contract = new ethers.Contract(loanPoolAddr, loanPoolABI)
    return contract
}