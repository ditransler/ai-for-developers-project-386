<script setup lang="ts">
import type { components } from '~/types/api.generated'

type EventType = components['schemas']['EventType']
type EventTypeCreate = components['schemas']['EventTypeCreate']
type EventTypeUpdate = components['schemas']['EventTypeUpdate']

const { t } = useI18n()
const toast = useToast()
const api = useBookingApi()

const { data: items, pending, error, refresh } = await useAsyncData(
  'admin-event-types',
  () => api.listAdminEventTypes(),
)

const modalOpen = ref(false)
const editing = ref<EventType | null>(null)
const deleteOpen = ref(false)
const deleteTarget = ref<EventType | null>(null)
const saving = ref(false)

const form = reactive({
  name: '',
  description: '',
  durationMinutes: 30,
})

function openCreate() {
  editing.value = null
  form.name = ''
  form.description = ''
  form.durationMinutes = 30
  modalOpen.value = true
}

function openEdit(et: EventType) {
  editing.value = et
  form.name = et.name
  form.description = et.description
  form.durationMinutes = et.durationMinutes
  modalOpen.value = true
}

function closeModal() {
  modalOpen.value = false
}

async function save() {
  saving.value = true
  try {
    if (editing.value) {
      const body: EventTypeUpdate = {
        name: form.name,
        description: form.description,
        durationMinutes: form.durationMinutes,
      }
      await api.updateEventType(editing.value.id, body)
      toast.add({ title: t('admin.save'), color: 'success' })
    }
    else {
      const body: EventTypeCreate = {
        id: crypto.randomUUID(),
        name: form.name,
        description: form.description,
        durationMinutes: form.durationMinutes,
      }
      await api.createEventType(body)
      toast.add({ title: t('admin.create'), color: 'success' })
    }
    closeModal()
    await refresh()
  }
  catch (e: unknown) {
    toast.add({
      title: getFetchErrorMessage(e, t('errors.generic')),
      color: 'error',
    })
  }
  finally {
    saving.value = false
  }
}

function openDelete(et: EventType) {
  deleteTarget.value = et
  deleteOpen.value = true
}

async function confirmDelete() {
  if (!deleteTarget.value)
    return
  saving.value = true
  try {
    await api.deleteEventType(deleteTarget.value.id)
    toast.add({ title: t('admin.delete'), color: 'success' })
    deleteOpen.value = false
    deleteTarget.value = null
    await refresh()
  }
  catch (e: unknown) {
    const msg = getFetchErrorMessage(e, t('errors.generic'))
    const status = (e as { statusCode?: number }).statusCode
    toast.add({
      title: status === 409 ? t('admin.deleteBlocked') : msg,
      color: 'error',
    })
  }
  finally {
    saving.value = false
  }
}
</script>

<template>
  <UContainer class="py-10">
    <div class="mb-8 flex flex-wrap items-center justify-between gap-4">
      <h1 class="text-2xl font-bold text-zinc-900">
        {{ t('admin.eventTypesTitle') }}
      </h1>
      <div class="flex gap-2">
        <UButton to="/admin" variant="outline" color="neutral">
          {{ t('admin.bookingsTitle') }}
        </UButton>
        <UButton color="primary" @click="openCreate">
          {{ t('admin.create') }}
        </UButton>
      </div>
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

    <div v-else class="space-y-4">
      <UCard
        v-for="et in items"
        :key="et.id"
        class="flex flex-col gap-4 p-6 sm:flex-row sm:items-center sm:justify-between"
      >
        <div class="min-w-0">
          <p class="font-semibold text-zinc-900">
            {{ et.name }}
          </p>
          <p class="mt-1 text-sm text-zinc-600">
            {{ et.description }}
          </p>
          <p class="mt-2 text-xs text-zinc-400">
            {{ et.id }} · {{ et.durationMinutes }} min
          </p>
        </div>
        <div class="flex shrink-0 gap-2">
          <UButton variant="outline" @click="openEdit(et)">
            {{ t('admin.edit') }}
          </UButton>
          <UButton color="error" variant="soft" @click="openDelete(et)">
            {{ t('admin.delete') }}
          </UButton>
        </div>
      </UCard>
    </div>

    <UModal v-model="modalOpen">
      <UCard>
        <template #header>
          <h2 class="text-lg font-semibold">
            {{ editing ? t('admin.editTitle') : t('admin.createTitle') }}
          </h2>
        </template>

        <div class="space-y-4">
          <UFormGroup :label="t('admin.name')">
            <UInput v-model="form.name" />
          </UFormGroup>
          <UFormGroup :label="t('admin.description')">
            <UTextarea v-model="form.description" />
          </UFormGroup>
          <UFormGroup :label="t('admin.duration')">
            <UInput v-model.number="form.durationMinutes" type="number" min="1" />
          </UFormGroup>
        </div>

        <template #footer>
          <div class="flex justify-end gap-2">
            <UButton variant="outline" @click="closeModal">
              {{ t('admin.cancel') }}
            </UButton>
            <UButton color="primary" :loading="saving" @click="save">
              {{ t('admin.save') }}
            </UButton>
          </div>
        </template>
      </UCard>
    </UModal>

    <UModal v-model="deleteOpen">
      <UCard v-if="deleteTarget">
        <template #header>
          <h2 class="text-lg font-semibold">
            {{ t('admin.deleteConfirm') }}
          </h2>
        </template>
        <p class="text-sm text-zinc-600">
          {{ deleteTarget.name }}
        </p>
        <template #footer>
          <div class="flex justify-end gap-2">
            <UButton variant="outline" @click="deleteOpen = false">
              {{ t('admin.cancel') }}
            </UButton>
            <UButton color="error" :loading="saving" @click="confirmDelete">
              {{ t('admin.delete') }}
            </UButton>
          </div>
        </template>
      </UCard>
    </UModal>
  </UContainer>
</template>
