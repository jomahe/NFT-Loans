<template>
  <div class="navbar bg-base-100 border-2 font-['Courier_New']">
    <div class="flex-1">
      <NuxtLink to="/" class="btn btn-ghost normal-case text-xl">NFT Loans</NuxtLink>
    </div>
    <div class="flex-none space-x-2">
      <NuxtLink to="/loans" class="btn">Create Loans</NuxtLink>
      <button class="btn" @click="connectWallet()">
        {{ account === undefined ? "Connect Wallet" : "🔗 " + account.slice(-6) }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"
const account = ethereum.selectedAddress

async function connectWallet() {
  if (window.ethereum !== undefined) {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' })
    account.value = accounts[0]

    // setup event listeners
    ethereum.on("accountsChanged", (_chainId) => window.location.reload())
    ethereum.on("chainChanged", (_chainId) => window.location.reload())
  }
}
</script>
