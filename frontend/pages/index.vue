<template>
<<<<<<< HEAD
  <div class="grid grid-cols-4 grid-rows-4 gap-10 mx-40 my-6">
    <!-- {{ contractAddress}} {{ tokenId}} -->
    <LoanPreviewBox v-for="nft in nfts" v-bind:key="nft.id" :contractAddress="nft.contractAddress" :tokenId="nft.tokenId" />
=======
  <div v-if="connected" class="grid grid-cols-3 auto-rows-auto gap-10 mx-40 my-6">
    <LoanPreviewBox v-for="loan in loans" :loan="loan" />
>>>>>>> 1f72afb20ced3e0996c44b5954ed1c12e6f0326c
  </div>
</template>

<script setup>
<<<<<<< HEAD
const currentBlockNumber = useCurrentBlockNumber()
const nfts = [{"contractAddress":"0x495f947276749Ce646f68AC8c248420045cb7b5e", "tokenId":"98745491564379547554924435713421898077677728399868739538264606794153742827521"}, {"contractAddress":"0x495f947276749Ce646f68AC8c248420045cb7b5e", "tokenId":"82025801317998859188275407380499659126889703202746411803471228386104328585217"}, {"contractAddress":"0x68Cd21D362C2DAe66909afD810e391fA152B2379", "tokenId":"64"}, {"contractAddress":"0x19b86299c21505cdf59cE63740B240A9C822b5E4", "tokenId":"753"}, {"contractAddress":"0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB", "tokenId":"9998"}]
</script>
=======
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
  const cnt = await contract.loanId()
  const activeLoans = []
  const pendingLoans = []
  for (let i = 1; i <= cnt; i++) {
    const a = await contract.accessActive(i)
    if (a.borrower !== "0x0000000000000000000000000000000000000000")
      activeLoans.push(a)
    const p = await contract.accessPending(i)
    if (p.borrower !== "0x0000000000000000000000000000000000000000")
      pendingLoans.push(p)
  }
  return activeLoans.concat(pendingLoans)
}


let loans = []
if (ethereum.selectedAddress !== null) {
  loans = await getLoans()

}
console.log(loans)
</script>
>>>>>>> 1f72afb20ced3e0996c44b5954ed1c12e6f0326c
