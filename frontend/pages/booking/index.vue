<script setup lang="ts">
const { t } = useI18n()
const appConfig = useAppConfig()
const api = useBookingApi()

const { data: eventTypes, pending, error } = await useAsyncData('public-event-types', () =>
  api.listPublicEventTypes(),
)
</script>

<template>
  <UContainer class="py-10">
    <UCard class="mb-10 bg-white shadow-sm ring-1 ring-zinc-200/80">
      <div class="flex flex-col gap-6 p-6 sm:flex-row sm:items-center sm:gap-8">
        <UAvatar
          :src="appConfig.calendarHost.avatarSrc"
          size="3xl"
          :alt="appConfig.calendarHost.displayName"
        />
        <div>
          <p class="text-sm text-zinc-500">
            {{ appConfig.calendarHost.displayName }}
          </p>
          <p class="text-xs uppercase tracking-wide text-zinc-400">
            {{ t('booking.host') }}
          </p>
          <h1 class="mt-2 text-2xl font-bold text-zinc-900">
            {{ t('booking.selectTypeTitle') }}
          </h1>
          <p class="mt-2 max-w-2xl text-zinc-600">
            {{ t('booking.selectTypeHint') }}
          </p>
        </div>
      </div>
    </UCard>

    <UAlert
      v-if="error"
      color="error"
      variant="soft"
      :title="t('errors.generic')"
      class="mb-6"
    />

    <div v-if="pending" class="flex justify-center py-16">
      <UIcon name="i-heroicons-arrow-path" class="size-10 animate-spin text-orange-500" />
    </div>

    <div
      v-else
      class="grid gap-6 sm:grid-cols-2"
    >
      <NuxtLink
        v-for="et in eventTypes"
        :key="et.id"
        :to="`/booking/${et.id}`"
        class="block"
      >
        <UCard class="h-full cursor-pointer p-6 transition hover:ring-2 hover:ring-orange-200">
          <div class="flex items-start justify-between gap-4">
            <div>
              <h2 class="text-lg font-semibold text-zinc-900">
                {{ et.name }}
              </h2>
              <p class="mt-2 text-sm text-zinc-600">
                {{ et.description }}
              </p>
            </div>
            <UBadge color="neutral" variant="soft">
              {{ t('booking.durationMin', { n: et.durationMinutes }) }}
            </UBadge>
          </div>
        </UCard>
      </NuxtLink>
    </div>
  </UContainer>
</template>
