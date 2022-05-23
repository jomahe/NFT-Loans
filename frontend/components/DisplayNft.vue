<template>

  <img class="rounded-xl" v-if="isImg" :src="nftUrl" alt="fail"> 

</template>

<script setup>
const props = defineProps(["nftUrl", "isImg"])

</script>

