<template>
  <div class="flex flex-col font-['Courier_New']">
    <input type="checkbox" id="my-modal" class="modal-toggle" v-model="toggle" />
    <label for="my-modal" class="modal cursor-pointer">
      <label class="modal-box relative" for="">
        <h3 class="text-lg font-bold">Select your NFT to use as collateral</h3>
        <div class="grid auto-rows-auto grid-cols-3 place-items-center gap-2 m-4">
          <img v-for="nft in assets" :key="nft.id" :src="nft.image_thumbnail_url" alt="empty nft" class="rounded-xl" />
        </div>
      </label>
    </label>

    <div class="flex flex-col space-y-4">
      <button @click="selectNFT" class="btn modal-button">Select an NFT</button>
      <button @click="approveNFT" class="btn">Authorize NFT</button>
      <!-- <button class="btn">Set Loan Terms</button> -->
      <div class="flex flex-row">
        <!-- <p class="flex-1">Loan <br> Denomination</p>
        <select class="select flex-1">
          <option disabled selected>Select</option>
          <option>ETH</option>
          <option>BTC</option>
          <option>USDT</option>
          <option>GMT</option>
          <option>DUY</option>
        </select> -->
      </div>

      <div class="flex items-center">
        <span class="flex-1 inline-block">Requested <br> Amount (ETH)</span>
        <input v-model="reqAmount" type="text" placeholder="0" class="input flex-1">
      </div>
      <div class="flex items-center">
        <span class="flex-1 inline-block">Loan Duration (days) </span>
        <input v-model="duration" type="text" placeholder="0" class="input flex-1 mx-4">
        <!-- <span class="flex-1 inline-block align-text-bottom">days</span> -->
      </div>
      <div class="flex items-center">
        <span class="flex-1 inline-block">Amount to Repay (ETH)</span>
        <input v-model="toPay" type="text" placeholder="0" class="input flex-1 mx-4">
        <!-- <span class="flex-1 inline-block">%</span> -->
      </div>
      <button @click="$emit('proposeLoan(reqAmount, duration, toPay)')" class="btn">Set Loan Terms and Create!</button>
      <!-- <button @click="proposeLoan(selectedNFT, tokenID, reqAmount, duration, toPay)" class="btn">Set Loan Terms and Create!</button> -->
    </div>
  </div>
</template>

<script setup>
const emit = defineEmits(['proposeLoan(reqAmount, duration, toPay)'])
const osKey = useRuntimeConfig().osKey
const toggle = ref(false)
const assets = ref()
const selectedNFT = ref()
const reqAmount = ref()
const duration = ref()
const toPay = ref()

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
  console.log(reqAmount)
  console.log(duration)
  console.log(toPay)
  console.log(assets.value)
  // display assets in a popup window
  toggle.value = true
}

async function approveNFT() {

}

</script>