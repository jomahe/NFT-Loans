<template>
  <div class="navbar bg-base-100 border-2 font-['Courier_New']">
    <div class="flex-1">
      <NuxtLink to="/" class="btn btn-ghost normal-case text-xl">NFT Loans</NuxtLink>
    </div>
    <div class="flex-none space-x-2">
      <NuxtLink to="/loans" class="btn">Create Loans</NuxtLink>
      <button class="btn" @click="connectWallet">
        {{ account !== null ? "🔗 " + account.slice(-6) : "Connect Wallet" }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"

const connected = computed(() => ethereum.selectedAddress !== null)
const account = ref(null)

async function connectWallet() {
  if (window.ethereum !== undefined) {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' })

    // setup event listeners
    ethereum.on("accountsChanged", (_chainId) => window.location.reload())
    ethereum.on("chainChanged", (_chainId) => window.location.reload())
  }
}

if (connected) {
  account.value = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
}
</script>
