<script lang="ts">
  import { onDestroy, onMount } from 'svelte';

  import Loader from '@replit-svelte/ui/icons/Loader.svelte';

  import { readFile } from '@replit/extensions';

  const dotenvFile = '.env';

  let value = '';
  let state: 'loading' | 'error' | 'ready' = 'loading';
  let loadingSecretsError: string | null = null;

  $: shouldShowOverlay = state != 'ready' || value.length <= 0;

  function loadSecrets(data: { error: string } | { content: string }) {
    if ('error' in data && typeof data.error == 'string') {
      state = 'error';
      loadingSecretsError = data.error;
      return;
    }

    state = 'ready';
    loadingSecretsError = null;

    value = data.content;
  }

  async function intervalCallback() {
    const data = await readFile(dotenvFile, 'utf8');
    loadSecrets(data);
  }

  let interval = 0;
  onMount(() => {
    intervalCallback();
    interval = setInterval(intervalCallback, 5000);
  });
  onDestroy(() => {
    clearInterval(interval);
  });
</script>

<svelte:head>
  <title>.env</title>
</svelte:head>

<h1 class="headerBig">.env</h1>

<div class="editorWrapper">
  {#if shouldShowOverlay}
    <div class="loadingSecrets">
      {#if loadingSecretsError == 'NOT_FOUND' || (!loadingSecretsError && value.length == 0)}
        <h2 class="subheadDefault">No secrets!</h2>
        <p class="wrapText">
          It seems like you haven't set any secrets. When you do, they'll show
          up here.
        </p>
      {:else if loadingSecretsError}
        <h2 class="subheadDefault">Error loading secrets!</h2>
        <code class="wrapText">{loadingSecretsError}</code>
      {:else}
        <Loader />
        <h2 class="subheadDefault">Loading secrets</h2>
      {/if}
    </div>
  {/if}
  <textarea disabled={shouldShowOverlay}>{value}</textarea>
</div>

<style>
  .editorWrapper {
    width: 100%;
    height: 100%;
    position: relative;
  }

  .loadingSecrets {
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
    text-align: center;
  }

  .wrapText {
    max-width: 50%;
  }

  textarea {
    width: 100%;
    height: 100%;
    resize: none;
  }
</style>
