<script lang="ts">
  import Input from '@replit-svelte/ui/Input.svelte';

  // File handler file path
  import { fileHandlerPath } from '$lib/stores';
</script>

<svelte:head>
  <title>File handler demo - Replit UI Svelte Extension</title>
</svelte:head>

This is a file handler.

{#if $fileHandlerPath}
  You selected the file:
  <Input value={$fileHandlerPath} disabled />
{:else}
  You haven't selected a file.
{/if}
