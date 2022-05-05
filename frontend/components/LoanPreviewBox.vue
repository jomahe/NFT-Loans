<template>
  <div class="card-bordered bg-base-100 shadow-xl rounded-xl border-black font-['Courier_New']" onclick="location.href='https://mcdonalds.com';" style="cursor: pointer;">
    <figure>
      <img :src="asset.image_url" :alt="asset.name" class="rounded-xl" />
    </figure>
    <div class="card-body items-center text-center">
      <a class="card bg-base-100 shadow-xl bordered-none"></a>
      <h2 class="card-title"><p>{{ asset.name }}</p></h2>
      <p>Loan Amount: 69420 ETH</p>
      <p>Loan Period: 690 days</p>
      <p>Interest: 0.69%</p>
      <p>Loan Status: 69 days left</p>
    </div>
  </div>
</template>

<script setup>
const props = defineProps(["tokenId", "contractAddress"])
const tokenId = props.tokenId, contractAddress = props.contractAddress

// get asset info from OpenSea
async function getOpenSeaAsset(tokenId, contractAddress) {
  const options = {method: 'GET', headers: {Accept: 'application/json', 'X-API-KEY': ' '}}
  const response = await fetch(`https://api.opensea.io/api/v1/assets?token_ids=${tokenId}&order_direction=desc&asset_contract_address=${contractAddress}&limit=20&include_orders=false`, options)
      .catch(err => console.error(err))
  return await response.json()
}

const asset = (await getOpenSeaAsset(tokenId, contractAddress)).assets[0]

console.log(asset)
</script>
