<template>
  <div v-if="connected" class="grid grid-cols-4 grid-rows-4 gap-10 mx-40 my-6">
    <LoanPreviewBox v-for="nft in nfts" v-bind:key="nft.id" :contractAddress="nft.contractAddress" :tokenId="nft.tokenId" />
  </div>
  <div v-else>
    <p class="text-center m-6">Connect wallet to view active loans</p>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

const account = ref(null)
const connected = computed(() => ethereum.selectedAddress !== null)

async function getLoans() {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    throw "Wallet isn't connected!"
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  account.value = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  // TODO: fetch loan info from contract and update components
  activeLoans = await contract.accessActive()
  pendingLoans = await contract.accessPending()
  console.log(activeLoans)
  console.log(pendingLoans)
}

console.log(ethereum.selectedAddress)

if (ethereum.selectedAddress !== null) {
  getLoans()

}
</script>
