<template>
  <div class="grid grid-rows-1 grid-cols-2 p-6">
    <LoanPreviewBox class="mx-auto" :loan="loan"></LoanPreviewBox>
    <div class="flex flex-col justify-around gap-4 px-20">
      <button class="btn">Accept</button>
      <button class="btn">Cancel</button>
      <button class="btn">Payoff</button>
      <button class="btn">Liquidate</button>
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

const route = useRoute()
const id = route.params.id

async function getLoan(id) {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  let loan = await contract.accessActive(id)
  if (loan.borrower === "0x0000000000000000000000000000000000000000") {
    loan = await contract.accessPending(id)
  }

  if (loan.borrower === "0x0000000000000000000000000000000000000000") {
    alert("This loan doesn't exist!")
  }

  return loan
}

const loan = await getLoan(id)
// console.log(loan)

</script>