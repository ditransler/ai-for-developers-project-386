<template>
  <div class="flex min-h-screen flex-col bg-zinc-50 text-zinc-900">
    <AppHeader />
    <main class="flex min-h-0 flex-1 flex-col">
      <slot />
    </main>
  </div>
</template>
