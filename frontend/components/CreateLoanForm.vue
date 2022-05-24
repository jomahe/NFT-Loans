<template>
  <div class="flex flex-col font-['Courier_New']">
    <input type="checkbox" id="my-modal" class="modal-toggle" v-model="toggle" />
    <label for="my-modal" class="modal cursor-pointer">
      <label class="modal-box relative" for="">
        <h3 class="text-lg font-bold">Select your NFT to use as collateral</h3>
        <div class="grid auto-rows-auto grid-cols-3 place-items-center gap-2 m-4">
          <img v-for="nft in assets" @click="$emit('nftSelected', nft.image_url)" :key="nft.id" :src="nft.image_url" alt="'empty nft'" class="rounded-xl" />
        </div>
      </label>
    </label>

    <div class="flex flex-col space-y-4">
      <button @click="selectNFT" class="btn modal-button">Select an NFT</button>
      <button @click="approveNFT" class="btn">Authorize NFT</button>

      <div class="flex items-center">
        <span class="flex-1 inline-block">Requested <br> Amount (ETH)</span>
        <input v-model="loanAmt" type="int" placeholder=0 class="input flex-1">
      </div>
      <div class="flex items-center">
        <span class="flex-1 inline-block">Loan Duration (days)</span>
        <input v-model="loanDur" type="int" placeholder=0 class="input flex-1 mx-4">
        <!-- <span class="flex-1 inline-block align-text-bottom">days</span> -->
      </div>
      <div class="flex items-center">
        <span class="flex-1 inline-block">Amount to Repay (ETH)</span>
        <input v-model="loanRate" type="int" placeholder=0 class="input flex-1 mx-4">
        <!-- <span class="flex-1 inline-block">%</span> -->
      </div>
      <button @click="sendForm" class="btn">Create Loan!</button>
      <!-- <button @click="proposeLoan(selectedNFT, tokenID, reqAmount, duration, toPay)" class="btn">Set Loan Terms and Create!</button> -->
    </div>
  </div>
</template>

<script setup>
const emit = defineEmits(['formFilled'])

const loanAmt = ref(null)
const loanDur = ref(null)
const loanRate = ref(null)

function sendForm() {
  // console.log(loanAmt.value, loanDur.value, loanRate.value)
  emit('formFilled', loanAmt.value, loanDur.value, loanRate.value)
}


const osKey = useRuntimeConfig().osKey
const toggle = ref(false)
const assets = ref()



async function selectNFT() {
  const options = { method: 'GET' };
  const account = useAccount()
  const owner = account.value
  if (owner === undefined) {
    alert("wallet isn't connected!")
    return
  }

  // get assets with opensea API
  const response = await fetch(`https://testnets-api.opensea.io/api/v1/assets?owner=${account.value}&order_direction=desc&offset=0&limit=20`, options)
    .then((response) => response.json())
    .catch(err => console.error(err))

  assets.value = response.assets
  // display assets in a popup window
  toggle.value = true
}

async function approveNFT() {

}

</script>