<template>
  <div class="grid grid-rows-1 grid-cols-2 p-6">
    <LoanPreviewBox class="mx-auto" :loan="loan"></LoanPreviewBox>
    <div class="flex flex-col justify-around gap-4 px-20">
      <button class="btn" @click="accept()">Accept</button>
      <button class="btn" @click="cancel()">Cancel</button>
      <button class="btn" @click="payOff()">Payoff</button>
      <button class="btn" @click="liq()">Liquidate</button>
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

async function accept() {
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)



  let loan = await contract.accessPending(id)
  // console.log(loan.requestedAmount)

  const tx = await contract.acceptLoan(id, { value: loan.requestedAmount })

  await tx.wait()

  console.log(tx)
}

async function cancel() {
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  const tx = await contract.retract(id)

  await tx.wait()

  console.log(tx)
}

async function payOff() {
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  let loan = await contract.accessActive(id)
  const tx = await contract.payInFull(id, { value: loan.toPay })

  await tx.wait()

  console.log(tx)
}

async function liq() {
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  const tx = await contract.liquidate(id)

  await tx.wait()

  console.log(tx)
}
const loan = await getLoan(id)
// console.log(loan)

</script>