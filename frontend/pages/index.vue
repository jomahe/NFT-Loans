<template>
  <div class="grid grid-cols-4 grid-rows-4 gap-10 mx-40 my-6">
    <!-- {{ contractAddress}} {{ tokenId}} -->
    <LoanPreviewBox v-for="nft in nfts" :contractAddress="nft.contractAddress" :tokenId="nft.tokenId" />
  </div>
</template>

<script setup>
const currentBlockNumber = useCurrentBlockNumber()
const nfts = [{"contractAddress":"0x495f947276749Ce646f68AC8c248420045cb7b5e", "tokenId":"98745491564379547554924435713421898077677728399868739538264606794153742827521"}, {"contractAddress":"0x495f947276749Ce646f68AC8c248420045cb7b5e", "tokenId":"82025801317998859188275407380499659126889703202746411803471228386104328585217"}, {"contractAddress":"0x68Cd21D362C2DAe66909afD810e391fA152B2379", "tokenId":"64"}, {"contractAddress":"0x19b86299c21505cdf59cE63740B240A9C822b5E4", "tokenId":"753"}, {"contractAddress":"0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB", "tokenId":"9998"}]
</script>