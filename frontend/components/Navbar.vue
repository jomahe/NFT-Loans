<template>
  <div class="navbar bg-sky-300 p-2 font-['Courier_New']">
    <div class="flex-1">
      <NuxtLink to="/" class="btn btn-ghost normal-case text-xl">
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="32" height="32" viewBox="0 0 256 256" xml:space="preserve">
          <defs>
          </defs>
          <g transform="translate(128 128) scale(0.72 0.72)" style="">
            <g style="stroke: none; stroke-width: 0; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: none; fill-rule: nonzero; opacity: 1;" transform="translate(-175.05 -175.05000000000004) scale(3.89 3.89)">
              <path d="M 44.798 53.715 c -0.294 0 -0.589 -0.087 -0.842 -0.262 L 18.08 35.61 c -0.337 -0.232 -0.563 -0.594 -0.624 -0.999 c -0.061 -0.405 0.047 -0.818 0.3 -1.139 L 43.632 0.551 c 0.281 -0.358 0.711 -0.567 1.166 -0.567 l 0 0 c 0.455 0 0.885 0.209 1.166 0.567 L 71.84 33.472 c 0.253 0.322 0.361 0.734 0.3 1.139 c -0.062 0.405 -0.288 0.766 -0.625 0.999 L 45.64 53.453 C 45.387 53.627 45.092 53.715 44.798 53.715 z M 21.065 34.064 l 23.733 16.365 l 23.733 -16.365 L 44.798 3.868 L 21.065 34.064 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(0,0,0); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
              <path d="M 44.798 89.984 c -0.002 0 -0.004 0 -0.005 0 c -0.466 -0.002 -0.904 -0.222 -1.183 -0.595 L 15.122 51.29 c -0.445 -0.595 -0.382 -1.427 0.148 -1.947 c 0.53 -0.519 1.362 -0.569 1.949 -0.114 L 44.81 70.638 l 27.614 -20.878 c 0.589 -0.448 1.42 -0.392 1.944 0.135 c 0.523 0.524 0.579 1.355 0.131 1.945 L 45.98 89.397 C 45.699 89.766 45.262 89.984 44.798 89.984 z M 24.067 58.298 l 20.74 27.737 l 20.82 -27.417 L 45.693 73.69 c -0.535 0.406 -1.274 0.399 -1.804 -0.011 L 24.067 58.298 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(0,0,0); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
            </g>
          </g>
        </svg>
        Collateral
      </NuxtLink>
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
