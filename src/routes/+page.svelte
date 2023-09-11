<script lang="ts">
  import { onMount } from 'svelte';

  import Loader from '@replit-svelte/ui/icons/Loader.svelte';

  import { readFile } from '@replit/extensions';

  let value = '';
  let loadingSecrets = true;
  let loadingSecretsError: string | null = null;

  onMount(async () => {
    const data = await readFile('.env', 'utf8');

    if ('error' in data) {
      loadingSecrets = false;
      loadingSecretsError = data.error;
      return;
    }

    value = data.content;
    loadingSecrets = false;
  });
</script>

<svelte:head>
  <title>.env</title>
</svelte:head>

<h1 class="headerBig">.env</h1>

<div class="editor-wrapper">
  {#if loadingSecrets || loadingSecretsError}
    <div class="loading-secrets">
      {#if loadingSecretsError}
        <h2 class="subheadDefault">Error loading secrets!</h2>
        <code>{loadingSecretsError}</code>
      {:else}
        <Loader />
        <h2 class="subheadDefault">Loading secrets</h2>
      {/if}
    </div>
  {/if}
  <textarea bind:value disabled={loadingSecrets}></textarea>
</div>

<style>
  .editor-wrapper {
    width: 100%;
    height: 100%;
    position: relative;
  }

  .loading-secrets {
    position: absolute;
    top: 0px;
    left: 0px;
    right: 0px;
    bottom: 0px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: var(--space-4);
    background-color: var(--background-overlay);
  }
  
  textarea {
    width: 100%;
    height: 100%;
    resize: none;
  }
</style>
