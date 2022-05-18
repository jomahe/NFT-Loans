import { defineNuxtConfig } from 'nuxt'

// https://v3.nuxtjs.org/api/configuration/nuxt.config
export default defineNuxtConfig({
    ssr: false,
    modules: ['@nuxtjs/tailwindcss'],
    publicRuntimeConfig: {
        osKey: '4b914cb8dc4743d6a34cb6549285876c'
    }
})
