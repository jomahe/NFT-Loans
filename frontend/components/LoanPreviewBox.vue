<template>
  <NuxtLink class="card bg-white/30 shadow-xl rounded-box border-black p-8" :to="`/loans/${id}`">
    <figure class="justify-self-center">
      <img :src="asset.image_url" :alt="asset.name" class="rounded-xl max-h-40 m-auto" />
    </figure>
    <div class="card-body items-center text-center p-4 font-['Courier_New']">
      <a class="card bg-base-100 shadow-xl bordered-none"></a>
      <h2 class="card-title">
        <p>{{ asset.name }}</p>
      </h2>
      <h1 class="font-bold">Loan #{{ id }}</h1>
      <!-- <p>Start Date: {{ timeStart == 0 ? "N/A" : timeStart }}</p> -->
      <p>{{ loanActive ? "Time Remaining: " + Number(timeEnd - timeStart) / 3600 + " hours"
        : "Duration: " + Number(timeEnd - timeStart) / 3600 + " hours"  }}</p>
      <p>Loan Amount: {{ ethers.utils.formatUnits(requestedAmount) }} ETH</p>
      <p>Amount to Pay: {{ ethers.utils.formatUnits(toPay) }} ETH</p>
      <p>Borrower: {{ borrower.slice(-6) }}</p>
      <p>Lender: {{ lender.slice(-6) == 0 ? "None" : lender.slice(-6) }}</p>
      <p>Loan Status: {{ loanActive ? "active" : "pending" }}</p>
    </div>
  </NuxtLink>
</template>

<script setup>
import { ethers } from "ethers"

const props = defineProps(["loan"])
const loan = props.loan
const borrower = loan.borrower, lender = loan.lender, nftAddress = loan.nft
const loanActive = loan.loanActive, paidOff = loan.paidOff

const id = loan.id.toBigInt(), nftId = loan.nftId.toBigInt(), timeStart = loan.timeStart.toBigInt(), timeEnd = loan.timeEnd.toBigInt(), requestedAmount = loan.requestedAmount.toBigInt(), toPay = loan.toPay.toBigInt()
// get asset info from OpenSea
async function getOpenSeaAsset(nftAddress, nftId) {
  const options = { method: 'GET', headers: { Accept: 'application/json', 'X-API-KEY': '' } }
  const response = await fetch(`https://testnets-api.opensea.io/api/v1/asset/${nftAddress}/${nftId}/`, options)
    .catch(err => console.error(err))
  return await response.json()
}

let asset = (await getOpenSeaAsset(nftAddress, nftId))

console.log(asset)

</script>
