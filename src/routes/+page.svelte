<script>
  import Button from '@replit-svelte/ui/Button.svelte';
  import Plus from '@replit-svelte/ui/icons/Plus.svelte';
  import { showModal, showToast } from '@replit-svelte/utils';

  import { messages } from '@replit/extensions';
</script>

<svelte:head>
  <title>Replit UI Svelte Extension</title>
</svelte:head>

<h1 class="headerBig">Replit UI Svelte Extension</h1>

<Button
  text="My button"
  on:click={() => {
    showModal({
      title: 'Button clicked',
      text: 'This is a demo Modal text',
    });
  }}
/>

<Button
  variant="primary"
  on:click={async () => {
    // Toast inside this pane
    showToast({
      text: 'Example toast 1',
      variant: 'primary',
    });

    // Toast outside this pane
    await messages.showNotice('Example toast 2');
  }}
>
  <Plus />
  Show toast
</Button>
