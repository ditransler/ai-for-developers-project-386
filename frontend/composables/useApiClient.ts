import type { FetchError } from 'ofetch'

export function useApiClient() {
  const config = useRuntimeConfig()
  return $fetch.create({
    baseURL: config.public.apiBase as string,
  })
}

export function getFetchErrorMessage(error: unknown, fallback: string): string {
  const e = error as FetchError<{ message?: string }>
  const msg = e.data && typeof e.data === 'object' && 'message' in e.data
    ? String((e.data as { message?: string }).message ?? '')
    : ''
  return msg || fallback
}
