<template>
  <div v-if="connected" class="grid grid-cols-3 auto-rows-auto gap-10 mx-40 my-6">
    <LoanPreviewBox v-for="loan in loans" :loan="loan" />
  </div>
</template>

<script setup>
import { ethers } from "ethers"

const connected = computed(() => ethereum.selectedAddress !== null)

async function getLoans() {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  // fetch loan info from contract and update components
  const cnt = await contract.loanId()
  const activeLoans = []
  const pendingLoans = []
  for (let i = 1; i <= cnt; i++) {
    const a = await contract.accessActive(i)
    if (a.borrower !== "0x0000000000000000000000000000000000000000" && a.toPay != 0)
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
// console.log(loans)
</script>
