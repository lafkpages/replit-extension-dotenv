<script>
  import { onMount } from 'svelte';

  import { showToast } from '@replit-svelte/utils';

  import { readFile } from '@replit/extensions';

  let value = '';

  onMount(async () => {
    const data = await readFile('.env', 'utf8');

    if ('error' in data) {
      if (data.error != 'NOT_FOUND') {
        showToast({
          text: `Error reading .env file: ${data.error}`,
          variant:"negative"
        });
      }
      return;
    }

    value = data.content;
  });
</script>

<svelte:head>
  <title>.env</title>
</svelte:head>

<h1 class="headerBig">.env</h1>

<textarea bind:value></textarea>

<style>
  textarea {
    height: 100%;
  }
</style>
