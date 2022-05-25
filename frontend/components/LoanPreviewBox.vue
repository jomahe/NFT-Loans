<template>
  <div class="card bg-base-100 shadow-xl rounded-xl border-black" onclick="location.href='https://mcdonalds.com'">
    <figure class="justify-self-center">
      <img :src="asset.image_url" :alt="asset.name" class="rounded-xl max-h-40 m-auto" />
    </figure>
    <div class="card-body items-center text-center p-4">
      <a class="card bg-base-100 shadow-xl bordered-none"></a>
      <h2 class="card-title">
        <p>{{ asset.name }}</p>
      </h2>
      <h1 class="font-bold">Loan #{{id}}</h1>
      <p>Start Date: {{ timeStart }}</p>
      <p>End Date: {{ timeEnd }}</p>
      <p>Loan Amount: {{ ethers.utils.formatUnits(requestedAmount) }} ETH</p>
      <p>Amount to Pay: {{ ethers.utils.formatUnits(toPay) }} ETH</p>
      <p>Borrower: {{ borrower.slice(-6) }}</p>
      <p>Lender = {{ lender.slice(-6) }}</p>
      <p>Loan Status: {{ loanActive ? "active" : "pending" }}</p>
    </div>
  </div>
</template>

<script setup>
<<<<<<< HEAD
const props = defineProps(["loanId"])
const loanId = props.loanId
const nftAddress = "0x000", nftId = 1
const borrower = "0x001", lender = "0x002", requestedAmount = 100, toPay = 110, timeStart = 10, timeEnd = 15, id = 1, active = true
// get loan info from contract
async function getLoanInfo(loanId) {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const account = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  // TODO: fetch loan info from contract and update components
}

=======
import {ethers} from "ethers"

const props = defineProps(["loan"])
const loan = props.loan
const borrower = loan.borrower, lender = loan.lender, nftAddress = loan.nft
const loanActive = loan.loanActive, paidOff = loan.paidOff

const id = loan.id.toBigInt(), nftId = loan.nftId.toBigInt(), timeStart = loan.timeStart.toBigInt(), timeEnd = loan.timeEnd.toBigInt(), requestedAmount = loan.requestedAmount.toBigInt(), toPay = loan.toPay.toBigInt()
console.log(ethers.utils.formatUnits(toPay))

>>>>>>> 1f72afb20ced3e0996c44b5954ed1c12e6f0326c
// get asset info from OpenSea
async function getOpenSeaAsset(nftAddress, nftId) {
  const options = { method: 'GET', headers: { Accept: 'application/json', 'X-API-KEY': '' } }
  const response = await fetch(`https://testnets-api.opensea.io/api/v1/asset/${nftAddress}/${nftId}/`, options)
    .catch(err => console.error(err))
  return await response.json()
}

const asset = (await getOpenSeaAsset(nftAddress, nftId))

console.log(asset)
</script>
