<template>
  <div class="flex flex-col space-y-4 font-['Courier_New']">
    <button class="btn">Select an NFT</button>
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
      </select>
    </div>
    <div class="flex items-center">
      <span class="flex-1 inline-block">Minimum <br>Loan Amount</span>
      <input type="text" placeholder="0" class="input flex-1">
    </div>
    <div class="flex items-center">
      <span class="flex-1 inline-block">Minimum Duration</span>
      <input type="text" placeholder="0" class="input flex-1" style = "position:relative; left:87px;">
      <span class="flex-1 inline-block align-text-bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;days</span>
    </div>
    <div class="flex items-center">
      <span class="flex-1 inline-block">Maximum Interest Rate</span>
      <input type="text" placeholder="0" class="input flex-1" style = "position:relative; left:87px;">
      <span class="flex-1 inline-block">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%</span>
    </div>
  </div>
</template>

<script setup>
</script>