<script setup lang="ts">
const route = useRoute()
const { t } = useI18n()

const bookActive = computed(() => route.path.startsWith('/booking'))
</script>

<template>
  <header
    class="border-b border-zinc-200/80 bg-white/80 backdrop-blur supports-[backdrop-filter]:bg-white/60"
  >
    <UContainer class="flex flex-wrap items-center justify-between gap-4 py-4">
      <NuxtLink
        to="/"
        class="flex items-center gap-2 font-semibold text-zinc-900"
      >
        <UIcon
          name="i-heroicons-calendar-days"
          class="size-7 text-orange-500"
        />
        {{ t('nav.brand') }}
      </NuxtLink>
      <nav class="flex items-center gap-2">
        <UButton
          to="/booking"
          variant="soft"
          color="neutral"
          :class="bookActive ? 'ring-2 ring-orange-200' : ''"
        >
          {{ t('nav.book') }}
        </UButton>
        <UButton to="/admin" variant="ghost" color="neutral">
          {{ t('nav.admin') }}
        </UButton>
      </nav>
    </UContainer>
  </header>
</template>
