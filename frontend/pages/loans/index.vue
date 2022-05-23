<template>
  <div class="flex flex-row space-x-10 p-10">
    <div class="flex-1">
      <DisplayNft class="mx-auto" :nftUrl="nftUrl" :isImg="isImg" />
    </div>
    <div class="flex-1">
      <CreateLoanForm @nft-selected=displayChange @form-filled=processForm />
    </div>
    <div class="flex-1">
      <LoanInstructions />
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

async function proposeLoan(params) {
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

const nftUrl = ref("https://lh3.googleusercontent.com/Z4KCLyF6e4TiX0gTG9LPBU7HAhPcKhAEgm5pWMpxDVEXNSljKtmcjKa9Zw9lks--GJhz9fdlBDWGzGh-4u6V-it21ByVj26P7QW86Q")
const isImg = ref(false)

function displayChange(url) {
  nftUrl.value = url
  isImg.value = true
}

function processForm(amt, duration, rate) {
  alert(amt)
  alert(duration)
  alert(rate)
}


</script>