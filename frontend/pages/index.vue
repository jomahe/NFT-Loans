<template>
  <div>
    Current block: {{ currentBlockNumber }}
  </div>
</template>

<script setup>
const currentBlockNumber = useCurrentBlockNumber()
</script>