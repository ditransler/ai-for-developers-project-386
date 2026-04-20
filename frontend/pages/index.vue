<script setup lang="ts">
const { t } = useI18n()
</script>

<template>
  <div class="landing-bg">
  <UContainer class="py-12 lg:py-20">
    <div class="grid gap-12 lg:grid-cols-2 lg:items-center">
      <div class="space-y-6">
        <UBadge color="neutral" variant="soft" size="lg">
          {{ t('landing.badge') }}
        </UBadge>
        <h1 class="text-4xl font-bold tracking-tight text-zinc-950 sm:text-5xl">
          {{ t('landing.title') }}
        </h1>
        <p class="max-w-xl text-lg text-zinc-600">
          {{ t('landing.subtitle') }}
        </p>
        <div>
          <UButton
            to="/booking"
            size="xl"
            color="primary"
            trailing-icon="i-heroicons-arrow-right"
          >
            {{ t('landing.cta') }}
          </UButton>
        </div>
      </div>
      <UCard class="bg-white/90 p-8 shadow-xl ring-1 ring-zinc-200/80">
        <h2 class="mb-6 text-xl font-semibold text-zinc-900">
          {{ t('landing.featuresTitle') }}
        </h2>
        <ul class="space-y-4 text-zinc-600">
          <li class="flex gap-3">
            <UIcon name="i-heroicons-check-circle" class="mt-0.5 size-5 shrink-0 text-orange-500" />
            <span>{{ t('landing.feature1') }}</span>
          </li>
          <li class="flex gap-3">
            <UIcon name="i-heroicons-check-circle" class="mt-0.5 size-5 shrink-0 text-orange-500" />
            <span>{{ t('landing.feature2') }}</span>
          </li>
          <li class="flex gap-3">
            <UIcon name="i-heroicons-check-circle" class="mt-0.5 size-5 shrink-0 text-orange-500" />
            <span>{{ t('landing.feature3') }}</span>
          </li>
        </ul>
      </UCard>
    </div>
  </UContainer>
  </div>
</template>

<style scoped>
.landing-bg {
  background: radial-gradient(1200px circle at 10% -10%, rgb(255 237 213), transparent 55%),
    radial-gradient(900px circle at 90% 0%, rgb(224 242 254), transparent 50%),
    linear-gradient(to bottom, rgb(250 250 250), rgb(244 244 245));
}
</style>
