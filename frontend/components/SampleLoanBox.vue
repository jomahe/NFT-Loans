<template>
  <NuxtLink class="card bg-white/30 shadow-xl rounded-box border-black p-8" :to="`/loans/${loan.id}`">
    <figure class="justify-self-center">
      <img :src="loan.image_url" :alt="loan.name" class="rounded-box max-h-40 m-auto" />
    </figure>
    <div class="card-body items-center text-center font-['Courier_New']">
      <a class="card bg-base-100 shadow-xl bordered-none"></a>
      <!-- <h2 class="card-title"
        <p>{{ loan.name }}</p>
      </h2> -->
      <h1 class="font-bold">Loan #{{ loan.id }}</h1>
      <p>{{ loan.loanActive ? "Time Remaining: " + loan.timeRemaining + " hours"
        : "Duration: " + loan.duration + " hours"  }}</p>
      <p>Loan Amount: {{ loan.requestedAmount }} ETH</p>
      <p>Amount to Pay: {{ loan.toPay }} ETH</p>
      <p>Borrower: {{ loan.borrower }}</p>
      <p>Lender: {{ loan.lender }}</p>
      <p>Loan Status: {{ loan.status }}</p>
    </div>
  </NuxtLink>
</template>

<script setup>

const props = defineProps(["loan"])
</script>