<template>
  <div class="flex flex-col font-['Courier_New']">
    <input type="checkbox" id="my-modal" class="modal-toggle" v-model="toggle" />
    <label for="my-modal" class="modal cursor-pointer">
      <label class="modal-box relative" for="">
        <h3 class="text-lg font-bold">Select your NFT to use as collateral</h3>
        <div class="grid auto-rows-auto grid-cols-3 place-items-center gap-2 m-4">
          <img v-for="nft in assets" @click="selectNFT(nft)" :key="nft.id" :src="nft.image_url" alt="'empty nft'" class="rounded-xl" />
        </div>
      </label>
    </label>

    <div class="flex flex-col space-y-4">
      <button @click="listNFT" class="btn modal-button">Select an NFT</button>
      <button @click="approveNFT" class="btn">Approve NFT</button>

      <div class="flex items-center">
        <span class="flex-1 inline-block font-bold">Requested <br> Amount (ETH)</span>
        <input v-model="loanAmt" type="int" placeholder=0 class="input flex-1 bg-white/30">
      </div>
      <div class="flex items-center">
        <span class="flex-1 inline-block font-bold">Loan Duration (days)</span>
        <input v-model="loanDur" type="int" placeholder=0 class="input flex-1 bg-white/30">
        <!-- <span class="flex-1 inline-block align-text-bottom">days</span> -->
      </div>
      <div class="flex items-center">
        <span class="flex-1 inline-block font-bold">Amount to Repay (ETH)</span>
        <input v-model="loanToPay" type="int" placeholder=0 class="input flex-1 bg-white/30">
        <!-- <span class="flex-1 inline-block">%</span> -->
      </div>
      <button @click="proposeLoan" class="btn">Create Loan!</button>
      <!-- <button @click="proposeLoan(selectedNFT, tokenID, reqAmount, duration, toPay)" class="btn">Set Loan Terms and Create!</button> -->
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"
import { loanPoolAddr, loanPoolABI } from "../composables/states";

const emit = defineEmits(['nftSelected'])

const loanAmt = ref(null)
const loanDur = ref(null)
const loanToPay = ref(null)
const osKey = useRuntimeConfig().osKey
const toggle = ref(false)
const assets = ref(null)
const selectedNFT = ref(null)

async function listNFT() {
  const options = { method: 'GET' };
  const account = ethereum.selectedAddress
  if (ethereum.selectedAddress === undefined) {
    alert("wallet isn't connected!")
    return
  }

  // get assets with opensea API
  const response = await fetch(`https://testnets-api.opensea.io/api/v1/assets?owner=${account}&order_direction=desc&offset=0&limit=20`, options)
    .then((response) => response.json())
    .catch(err => console.error(err))

  assets.value = response.assets
  // display assets in a popup window
  toggle.value = true
}

function selectNFT(nft) {
  selectedNFT.value = nft
  console.log(nft.asset_contract.address)
  emit('nftSelected', nft.image_url)
}

async function approveNFT() {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }
  if (selectedNFT.value === null) {
    alert("Please select an NFT first")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = useCollateralContract(selectedNFT.value.asset_contract.address).connect(signer)
  console.log(selectedNFT.value)
  const tx = await contract.approve(loanPoolAddr, selectedNFT.value.token_id)
  await tx.wait()
  console.log(tx)
}

async function proposeLoan() {
  if (window.ethereum === undefined) {
    alert("Wallet isn't connected!")
    return
  }

  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()
  const contract = new ethers.Contract(loanPoolAddr, loanPoolABI, signer)

  // console.log(loanAmt.value, ethers.utils.parseUnits(loanAmt.value.toString(), 'ether'))

  const tx = await contract.propose(
    selectedNFT.value.asset_contract.address,
    selectedNFT.value.token_id,
    ethers.utils.parseUnits(loanAmt.value.toString(), 'ether'),
    ethers.utils.parseUnits(loanToPay.value.toString(), 'ether'),
    loanDur.value
  )

  await tx.wait()

  console.log(tx)
}

</script>