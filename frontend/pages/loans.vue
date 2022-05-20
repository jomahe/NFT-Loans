<template>
  <div class="flex flex-row space-x-10 p-10">
    <div class="flex-1">
      display the selected NFT
    </div>
    <div class="flex-1">
      <CreateLoanForm @proposeLoan="proposeLoan"/>
    </div>
    <div class="flex-1">
      <LoanInstructions />
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

async function proposeLoan() {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const account = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
  const signer = provider.getSigner()
  const contract = useLoanPoolContract()
  contract.connect(signer)
  
  console.log(contract)

}
</script>