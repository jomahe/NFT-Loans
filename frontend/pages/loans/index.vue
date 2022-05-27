<template>
<div class="flex flex-col p-10 h-screen">
  <InstructionsBar />
  <div class="flex flex-row space-x-10 p-10">
    <div class="flex-1">
      <DisplayNft class="mx-auto" :nftUrl="nftUrl" :isImg="isImg" />
    </div>
    <div class="flex-1">
      <CreateLoanForm @nft-selected="displayChange" />
    </div>
    <div class="flex-1">
      <LoanInstructions />
    </div>
  </div>
</div>
</template>

<script setup>
import { ethers } from "ethers"
import { loanPoolAddr, loanPoolABI } from "../../composables/states.js"

const nftUrl = ref("")
const isImg = ref(false)

function displayChange(url) {
  nftUrl.value = url
  isImg.value = true
}

</script>