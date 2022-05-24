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
      <p>Start Date: {{timeStart}}</p>
      <p>End Date: {{timeEnd}}</p>
      <p>Loan Amount: {{requestedAmount}} ETH</p>
      <p>Interest Rate: {{(toPay - requestedAmount) / (timeEnd - timeStart)}}</p>
      <p>Borrower: {{borrower}}</p>
      <p>Lender = {{lender}}</p>
      <p>Loan Status: {{ active ? "active" : "inactive"}}</p>
    </div>
  </div>
</template>

<script setup>
console.log("i'm loaded")
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
  activeLoans = await contract.accessActive()
  pendingLoans = await contract.accessPending()
  console.log(activeLoans)
  console.log(pendingLoans)
}

getLoanInfo(loanId)

// get asset info from OpenSea
async function getOpenSeaAsset(nftId, nftAddress) {
  const options = { method: 'GET', headers: { Accept: 'application/json', 'X-API-KEY': '' } }
  const response = await fetch(`https://api.opensea.io/api/v1/asset/${nftAddress}/${nftId}/?include_orders=false`, options)
    .catch(err => console.error(err))
  return await response.json()
}

const asset = (await getOpenSeaAsset(nftId, nftAddress))

// console.log(asset)
</script>
