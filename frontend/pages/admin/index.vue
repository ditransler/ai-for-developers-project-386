<script setup lang="ts">
const { t } = useI18n()
const api = useBookingApi()

const { data: bookings, pending, error } = await useAsyncData(
  'admin-bookings',
  () => api.listAdminBookings(),
)

function formatWhen(iso: string) {
  return new Intl.DateTimeFormat('en', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(iso))
}
</script>

<template>
  <UContainer class="py-10">
    <div class="mb-8 flex flex-wrap items-center justify-between gap-4">
      <h1 class="text-2xl font-bold text-zinc-900">
        {{ t('admin.bookingsTitle') }}
      </h1>
      <UButton to="/admin/event-types" color="primary" variant="outline">
        {{ t('admin.eventTypesTitle') }}
      </UButton>
    </div>

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

    <UCard v-else-if="bookings?.length" class="divide-y divide-zinc-100">
      <div
        v-for="b in bookings"
        :key="b.id"
        class="flex flex-col gap-1 px-6 py-4 sm:flex-row sm:items-center sm:justify-between"
      >
        <div>
          <p class="font-medium text-zinc-900">
            {{ b.eventTypeName }}
          </p>
          <p class="text-sm text-zinc-600">
            {{ formatWhen(b.startAt) }} — {{ formatWhen(b.endAt) }}
          </p>
          <p v-if="b.guestDisplayName" class="text-sm text-zinc-500">
            {{ b.guestDisplayName }}
          </p>
        </div>
      </div>
    </UCard>

    <p v-else class="py-12 text-center text-zinc-500">
      {{ t('admin.bookingsEmpty') }}
    </p>
  </UContainer>
</template>
