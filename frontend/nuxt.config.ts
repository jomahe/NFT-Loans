import { defineNuxtConfig } from 'nuxt'

// https://v3.nuxtjs.org/api/configuration/nuxt.config
export default defineNuxtConfig({
    ssr: false,
    modules: ['@nuxtjs/tailwindcss'],
    publicRuntimeConfig: {
        osKey: '067226657bd4474293f5f57da67dfe63'
    }
})
