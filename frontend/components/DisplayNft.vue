<template>

  <img class="rounded-xl max-h-max object-center" v-if="isImg" :src="nftUrl" alt="fail"> 

</template>

<script setup>
const props = defineProps(["nftUrl", "isImg"])

</script>

