<script setup lang="ts">
const route = useRoute()
const { t } = useI18n()

const bookActive = computed(() => route.path.startsWith('/booking'))
const adminActive = computed(() => route.path.startsWith('/admin'))
</script>

<template>
  <header
    class="border-b border-zinc-200/80 bg-white shadow-[0_1px_3px_rgba(15,23,42,0.06)]"
  >
    <UContainer class="flex flex-wrap items-center justify-between gap-4 py-4">
      <NuxtLink
        to="/"
        class="flex items-center gap-2.5 text-zinc-900 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-orange-400 focus-visible:ring-offset-2"
      >
        <svg
          class="size-7 shrink-0 text-orange-500"
          viewBox="0 0 24 24"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          aria-hidden="true"
        >
          <rect
            x="3.5"
            y="5"
            width="17"
            height="15.5"
            rx="2"
            stroke="currentColor"
            stroke-width="1.75"
          />
          <circle
            cx="12"
            cy="13.5"
            r="3.25"
            stroke="currentColor"
            stroke-width="1.75"
          />
          <line
            x1="12"
            y1="13.5"
            x2="12"
            y2="10.25"
            stroke="currentColor"
            stroke-width="1.75"
            stroke-linecap="round"
          />
        </svg>
        <span class="text-base font-bold tracking-tight">{{
          t('nav.brand')
        }}</span>
      </NuxtLink>
      <nav
        class="flex items-center gap-8 text-sm font-medium text-zinc-600"
        aria-label="Main"
      >
        <NuxtLink
          to="/booking"
          class="transition-colors hover:text-zinc-900 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-orange-400 focus-visible:ring-offset-2 rounded-sm"
          :class="bookActive ? 'text-orange-600' : ''"
        >
          {{ t('nav.book') }}
        </NuxtLink>
        <NuxtLink
          to="/admin"
          class="transition-colors hover:text-zinc-900 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-orange-400 focus-visible:ring-offset-2 rounded-sm"
          :class="adminActive ? 'text-orange-600' : ''"
        >
          {{ t('nav.admin') }}
        </NuxtLink>
      </nav>
    </UContainer>
  </header>
</template>
