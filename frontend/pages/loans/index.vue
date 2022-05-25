<template>
  <div class="flex flex-row space-x-10 p-10">
    <div class="flex-1">
      <DisplayNft class="mx-auto" :nftUrl="nftUrl" :isImg="isImg" />
    </div>
    <div class="flex-1">
      <CreateLoanForm @nft-selected=displayChange />
    </div>
    <div class="flex-1">
      <LoanInstructions />
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"
import { loanPoolAddr, loanPoolABI } from "../../composables/states.js"

const nftUrl = ref("https://lh3.googleusercontent.com/Z4KCLyF6e4TiX0gTG9LPBU7HAhPcKhAEgm5pWMpxDVEXNSljKtmcjKa9Zw9lks--GJhz9fdlBDWGzGh-4u6V-it21ByVj26P7QW86Q")
const isImg = ref(false)

function displayChange(url) {
  nftUrl.value = url
  isImg.value = true
}

</script>