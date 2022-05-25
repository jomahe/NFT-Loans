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
      <button @click="proposeLoan" class="btn">Create Loan!</button>
      <!-- <button @click="proposeLoan(selectedNFT, tokenID, reqAmount, duration, toPay)" class="btn">Set Loan Terms and Create!</button> -->
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

const emit = defineEmits(['nftSelected'])

const loanAmt = ref(null)
const loanDur = ref(null)
const loanRate = ref(null)
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
    3,
    ethers.utils.parseUnits(reqAmount.toString(), 'ether'),
    ethers.utils.parseUnits(toPay.toString(), 'ether'),
    duration
  )

  await tx.wait()

  console.log(tx)
}

</script>