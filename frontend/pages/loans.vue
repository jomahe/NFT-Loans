<template>
  <div class="flex flex-row space-x-10 p-10">
    <div class="flex-1">
      display the selected NFT
    </div>
    <div class="flex-1">
      <CreateLoanForm @proposeLoan="proposeLoan(reqAmount, duration, toPay)"/>
    </div>
    <div class="flex-1">
      <LoanInstructions />
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

async function proposeLoan(reqAmount, duration, toPay) {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const account = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
  const signer = provider.getSigner()
  const contract = useLoanPoolContract().connect(signer)

  // nft = 0x19c42ab6Bc7a0F5FA771d9f5B4aC7b5a831D8233
  // nftId = 2

  const tx = await contract.propose(
    0x19c42ab6Bc7a0F5FA771d9f5B4aC7b5a831D8233,
    2,
    Number(reqAmount),
    Number(toPay),
    Number(duration)
  )

  await tx.wait()

  console.log(tx)

  console.log(Number(await contract.feePercent()))
}

</script>