<template>
  <div class="navbar bg-base-100 border-2">
    <div class="flex-1">
      <a class="btn btn-ghost normal-case text-xl">NFT Loans</a>
    </div>
    <div class="flex-none">
      <button class="btn" @click="connectWallet()">
        {{ account === undefined ? "Connect Wallet" : account }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ethers } from "ethers"
const account = useAccount()
const currentBlockNumber = useCurrentBlockNumber()

async function connectWallet() {
  if (window.ethereum !== undefined) {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' })
    account.value = accounts[0]

    // setup event listeners
    ethereum.on("accountsChanged", (_chainId) => window.location.reload())
    ethereum.on("chainChanged", (_chainId) => window.location.reload())
    provider.on("block", (blockNumber) => {
      currentBlockNumber.value = blockNumber
    })

  }
}
</script>
