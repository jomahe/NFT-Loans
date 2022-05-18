<template>
  <input type="checkbox" id="my-modal" class="modal-toggle" v-model="toggle" />
  <label for="my-modal" class="modal cursor-pointer">
    <label class="modal-box relative" for="">
      <h3 class="text-lg font-bold">Select your NFT to use as collateral</h3>
      <p class="py-4">NFT1, NFT2, NFT3</p>
    </label>
  </label>

  
  <div class="flex flex-col space-y-4 font-['Courier_New']">
    <button @click="selectNFT" class="btn modal-button">Select an NFT</button>
    <button class="btn">Authorize NFT</button>
    <button class="btn">Set Loan Terms</button>
    <div class="flex flex-row">
      <p class="flex-1">Loan <br> Denomination</p>
      <select class="select flex-1">
        <option disabled selected>Select</option>
        <option>ETH</option>
        <option>BTC</option>
        <option>USDT</option>
        <option>GMT</option>
        <option>DUY</option>
      </select>
    </div>
    <div class="flex items-center">
      <span class="flex-1 inline-block">Minimum <br>Loan Amount</span>
      <input type="text" placeholder="0" class="input flex-1">
    </div>
    <div class="flex items-center">
      <span class="flex-1 inline-block">Minimum Duration</span>
      <input type="text" placeholder="0" class="input flex-1 mx-4">
      <span class="flex-1 inline-block align-text-bottom">days</span>
    </div>
    <div class="flex items-center">
      <span class="flex-1 inline-block">Maximum Interest Rate</span>
      <input type="text" placeholder="0" class="input flex-1 mx-4">
      <span class="flex-1 inline-block">%</span>
    </div>
  </div>
</template>

<script setup>
const osKey = useRuntimeConfig().osKey
const toggle = ref(false)

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

  const assets = response.assets
  console.log(assets)

  // display assets in a popup window
  toggle.value = true
}



</script>