<script lang="ts">
  import { onDestroy, onMount } from 'svelte';

  import Button from '@replit-svelte/ui/Button.svelte';
  import Loader from '@replit-svelte/ui/icons/Loader.svelte';

  import { showToast } from '@replit-svelte/utils';

  import { readFile, writeFile } from '@replit/extensions';

  const dotenvFile = '.env';

  let editor: HTMLTextAreaElement | null = null;

  let value = '';
  let state: 'loading' | 'error' | 'ready' = 'loading';
  let loadingSecretsError: string | null = null;

  let edited = false;

  $: shouldShowOverlay = state != 'ready' || value.length <= 0;

  function loadSecrets(data: { error: string } | { content: string }) {
    if ('error' in data && typeof data.error == 'string') {
      state = 'error';
      loadingSecretsError = data.error;
      return;
    }

    if (!('content' in data) || typeof data.content != 'string') {
      return;
    }

    state = 'ready';
    loadingSecretsError = null;

    value = data.content;
  }

  async function intervalCallback() {
    // If the user is editing the file, don't overwrite
    // editor contents
    if (edited) {
      return;
    }

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

  let copyButtonState: 'copy' | 'copying' | 'copied' = 'copy';
</script>

<svelte:head>
  <title>.env</title>
</svelte:head>

<header>
  <h1 class="headerBig">.env</h1>

  <div class="button-row">
    <Button
      variant="primary"
      disabled={!edited}
      on:click={() => {
        if (!editor) {
          return;
        }

        writeFile(dotenvFile, editor.value).then((data) => {
          if ('error' in data && typeof data.error == 'string') {
            showToast({
              text: `Error saving secrets: ${data.error}`,
              variant: 'negative',
            });
            return;
          }

          if (editor) {
            value = editor.value;
          }
          edited = false;
        });
      }}
    >
      Save
    </Button>

    <Button
      variant="primary"
      on:click={() => {
        copyButtonState = 'copying';

        navigator.clipboard
          .writeText(value)
          .then(() => {
            copyButtonState = 'copied';
            setTimeout(() => {
              copyButtonState = 'copy';
            }, 1000);
          })
          .catch((err) => {
            copyButtonState = 'copy';

            showToast({
              text: err,
              variant: 'negative',
            });
          });
      }}
    >
      {{
        copy: 'Copy',
        copying: 'Copying...',
        copied: 'Copied!',
      }[copyButtonState]}
    </Button>
  </div>
</header>

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
  <textarea
    bind:this={editor}
    disabled={shouldShowOverlay}
    on:input={(e) => {
      if (!editor) {
        e.preventDefault();
        return;
      }

      edited = value != editor.value;
    }}>{value}</textarea
  >
</div>

<style>
  header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

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
