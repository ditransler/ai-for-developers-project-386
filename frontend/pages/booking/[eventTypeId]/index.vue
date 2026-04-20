<script setup lang="ts">
import type { components } from '~/types/api.generated'
import { dateKeyLocal, formatLongDate, formatTimeRange, parseDateKeyLocal } from '~/utils/date'

type TimeSlot = components['schemas']['TimeSlot']

const { t } = useI18n()
const route = useRoute()
const appConfig = useAppConfig()
const api = useBookingApi()
const paramId = route.params.eventTypeId as string

const { data: eventType, error: typeError } = await useAsyncData(
  `event-type-${paramId}`,
  async () => {
    const list = await api.listPublicEventTypes()
    return list.find((e) => e.id === paramId) ?? null
  },
)

if (!typeError.value && eventType.value === null) {
  throw createError({ statusCode: 404, statusMessage: 'Event type not found' })
}

const {
  data: slots,
  pending: slotsPending,
  error: slotsError,
} = await useAsyncData(`slots-${paramId}`, () => api.listAvailableSlots(paramId))

const slotsByDay = computed(() => {
  const m = new Map<string, TimeSlot[]>()
  for (const s of slots.value ?? []) {
    const k = dateKeyLocal(s.startAt)
    if (!m.has(k))
      m.set(k, [])
    m.get(k)!.push(s)
  }
  for (const [, arr] of m)
    arr.sort((a, b) => a.startAt.localeCompare(b.startAt))
  return m
})

const selectedDateKey = ref<string | null>(null)
const selectedSlot = ref<TimeSlot | null>(null)

watch(
  slotsByDay,
  (m) => {
    const keys = [...m.keys()].sort()
    if (!keys.length) {
      selectedDateKey.value = null
      selectedSlot.value = null
      return
    }
    if (!selectedDateKey.value || !m.has(selectedDateKey.value))
      selectedDateKey.value = keys[0]!
  },
  { immediate: true },
)

watch(selectedDateKey, () => {
  selectedSlot.value = null
})

const viewMonth = ref(new Date())

watch(
  selectedDateKey,
  (k) => {
    if (k) {
      const d = parseDateKeyLocal(k)
      viewMonth.value = new Date(d.getFullYear(), d.getMonth(), 1)
    }
  },
  { immediate: true },
)

function localKey(y: number, monthIndex: number, day: number): string {
  const d = new Date(y, monthIndex, day, 12, 0, 0)
  return dateKeyLocal(d.toISOString())
}

const calendarCells = computed(() => {
  const v = viewMonth.value
  const y = v.getFullYear()
  const m = v.getMonth()
  const first = new Date(y, m, 1)
  const startPad = (first.getDay() + 6) % 7
  const daysInMonth = new Date(y, m + 1, 0).getDate()
  const cells: { label: number | null; key: string | null; inMonth: boolean }[] = []
  for (let i = 0; i < startPad; i++)
    cells.push({ label: null, key: null, inMonth: false })
  for (let d = 1; d <= daysInMonth; d++) {
    const key = localKey(y, m, d)
    cells.push({ label: d, key, inMonth: true })
  }
  return cells
})

const monthLabel = computed(() =>
  new Intl.DateTimeFormat('en', { month: 'long', year: 'numeric' }).format(viewMonth.value),
)

function shiftMonth(delta: number) {
  const v = viewMonth.value
  viewMonth.value = new Date(v.getFullYear(), v.getMonth() + delta, 1)
}

const slotsForSelectedDay = computed(() => {
  const k = selectedDateKey.value
  if (!k)
    return []
  return slotsByDay.value.get(k) ?? []
})

const selectedDateLabel = computed(() => {
  if (!selectedDateKey.value)
    return '—'
  return formatLongDate(parseDateKeyLocal(selectedDateKey.value))
})

const selectedTimeLabel = computed(() => {
  if (!selectedSlot.value)
    return t('booking.timeNotSelected')
  return formatTimeRange(selectedSlot.value.startAt, selectedSlot.value.endAt)
})

function selectDay(key: string) {
  if (!slotsByDay.value.has(key))
    return
  selectedDateKey.value = key
}

function goBackToCatalog() {
  navigateTo('/booking')
}

function onContinue() {
  if (!selectedSlot.value)
    return
  navigateTo({
    path: `/booking/${paramId}/confirm`,
    query: { startAt: selectedSlot.value.startAt },
  })
}

function slotCountForKey(key: string | null) {
  if (!key)
    return 0
  return slotsByDay.value.get(key)?.length ?? 0
}
</script>

<template>
  <UContainer class="py-10">
    <UAlert
      v-if="typeError"
      color="error"
      variant="soft"
      :title="t('errors.generic')"
      class="mb-6"
    />

    <div
      v-else-if="eventType"
      class="grid gap-6 lg:grid-cols-3"
    >
      <!-- Summary -->
      <UCard class="h-fit bg-white shadow-sm ring-1 ring-zinc-200/80">
        <div class="flex items-start gap-4 p-6">
          <UAvatar
            :src="appConfig.calendarHost.avatarSrc"
            size="3xl"
            :alt="appConfig.calendarHost.displayName"
          />
          <div class="min-w-0">
            <p class="font-medium text-zinc-900">
              {{ appConfig.calendarHost.displayName }}
            </p>
            <p class="text-xs text-zinc-500">
              {{ t('booking.host') }}
            </p>
          </div>
        </div>
        <div class="border-t border-zinc-100 px-6 py-4">
          <div class="flex items-start justify-between gap-2">
            <h1 class="text-lg font-semibold text-zinc-900">
              {{ eventType.name }}
            </h1>
            <UBadge color="neutral" variant="soft">
              {{ t('booking.durationMin', { n: eventType.durationMinutes }) }}
            </UBadge>
          </div>
          <p class="mt-2 text-sm text-zinc-600">
            {{ eventType.description }}
          </p>
        </div>
        <div class="space-y-3 border-t border-zinc-100 bg-sky-50/60 p-4">
          <div>
            <p class="text-xs font-medium text-sky-900/80">
              {{ t('booking.selectedDate') }}
            </p>
            <p class="text-sm text-sky-950">
              {{ selectedDateLabel }}
            </p>
          </div>
          <div>
            <p class="text-xs font-medium text-sky-900/80">
              {{ t('booking.selectedTime') }}
            </p>
            <p class="text-sm text-sky-950">
              {{ selectedTimeLabel }}
            </p>
          </div>
        </div>
      </UCard>

      <!-- Calendar -->
      <UCard class="bg-white shadow-sm ring-1 ring-zinc-200/80">
        <div class="flex items-center justify-between border-b border-zinc-100 px-4 py-3">
          <h2 class="font-semibold text-zinc-900">
            {{ t('booking.calendarTitle') }}
          </h2>
          <div class="flex gap-1">
            <UButton
              icon="i-heroicons-chevron-left"
              variant="ghost"
              color="neutral"
              @click="shiftMonth(-1)"
            />
            <UButton
              icon="i-heroicons-chevron-right"
              variant="ghost"
              color="neutral"
              @click="shiftMonth(1)"
            />
          </div>
        </div>
        <p class="px-4 pt-3 text-center text-sm font-medium text-zinc-700">
          {{ monthLabel }}
        </p>
        <div class="grid grid-cols-7 gap-1 px-2 pb-4 pt-2 text-center text-xs text-zinc-500">
          <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
        </div>
        <div class="grid grid-cols-7 gap-1 px-2 pb-4">
          <template v-for="(cell, idx) in calendarCells" :key="idx">
            <div v-if="cell.label === null" class="h-10" />
            <UButton
              v-else
              variant="ghost"
              :color="selectedDateKey === cell.key ? 'primary' : 'neutral'"
              class="h-10 min-w-0 px-0"
              :disabled="!cell.key || !slotsByDay.has(cell.key)"
              :class="selectedDateKey === cell.key ? 'ring-2 ring-orange-400' : ''"
              @click="cell.key && selectDay(cell.key)"
            >
              <span class="flex flex-col items-center gap-0.5 text-[11px] leading-none">
                <span>{{ cell.label }}</span>
                <span
                  v-if="cell.key && slotCountForKey(cell.key) > 0"
                  class="font-normal text-[10px] text-zinc-500"
                >
                  {{ t('booking.slotsForDay', { n: slotCountForKey(cell.key) }) }}
                </span>
              </span>
            </UButton>
          </template>
        </div>
      </UCard>

      <!-- Slots -->
      <UCard class="bg-white shadow-sm ring-1 ring-zinc-200/80">
        <div class="border-b border-zinc-100 px-4 py-3">
          <h2 class="font-semibold text-zinc-900">
            {{ t('booking.slotStatusTitle') }}
          </h2>
        </div>
        <div class="p-4">
          <div v-if="slotsPending" class="flex justify-center py-10">
            <UIcon name="i-heroicons-arrow-path" class="size-8 animate-spin text-orange-500" />
          </div>
          <UAlert
            v-else-if="slotsError"
            color="error"
            variant="soft"
            :title="t('booking.loadError')"
          />
          <ul
            v-else-if="slotsForSelectedDay.length"
            class="max-h-80 space-y-2 overflow-auto"
          >
            <li v-for="slot in slotsForSelectedDay" :key="slot.startAt">
              <UButton
                block
                :variant="selectedSlot?.startAt === slot.startAt ? 'solid' : 'outline'"
                color="primary"
                class="justify-between"
                @click="selectedSlot = slot"
              >
                <span>{{ formatTimeRange(slot.startAt, slot.endAt) }}</span>
                <span class="text-xs font-semibold uppercase">
                  {{ t('booking.available') }}
                </span>
              </UButton>
            </li>
          </ul>
          <p v-else class="py-6 text-center text-sm text-zinc-500">
            {{ t('booking.noSlotsDay') }}
          </p>
        </div>
        <div class="flex flex-wrap gap-2 border-t border-zinc-100 p-4">
          <UButton variant="outline" color="neutral" @click="goBackToCatalog">
            {{ t('booking.back') }}
          </UButton>
          <UButton
            color="primary"
            :disabled="!selectedSlot"
            @click="onContinue"
          >
            {{ t('booking.continue') }}
          </UButton>
        </div>
      </UCard>
    </div>
  </UContainer>
</template>
