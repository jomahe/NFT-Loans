<template>
  <div class="flex flex-row space-x-10 p-10">
    <div class="flex-1">
      <DisplayNft class="mx-auto" :nftUrl="nftUrl" :isImg="isImg" />
    </div>
    <div class="flex-1">
      <CreateLoanForm @nft-selected="displayChange" @form-filled="processForm" />
    </div>
    <div class="flex-1">
      <LoanInstructions />
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"
import { loanPoolAddr, loanPoolABI } from "../../composables/states.js"

async function proposeLoan(reqAmount, duration, toPay) {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }

  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const account = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
  const signer = provider.getSigner()
  const contract = new ethers.Contract(loanPoolAddr.toString(), loanPoolABI, signer)

  const tx = await contract.propose(
    "0x60e594700A50232b0af32572A7A4B648aB88Ff98",
    4,
    ethers.utils.parseUnits(reqAmount.toString(), 'ether'),
    ethers.utils.parseUnits(toPay.toString(), 'ether'),
    duration
  )

  await tx.wait()

  console.log(tx)
}

const nftUrl = ref("https://lh3.googleusercontent.com/Z4KCLyF6e4TiX0gTG9LPBU7HAhPcKhAEgm5pWMpxDVEXNSljKtmcjKa9Zw9lks--GJhz9fdlBDWGzGh-4u6V-it21ByVj26P7QW86Q")
const isImg = ref(false)

function displayChange(url) {
  nftUrl.value = url
  isImg.value = true
}

function processForm(amt, duration, toPay) {
  proposeLoan(amt, duration, toPay)
}


</script>