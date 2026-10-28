import { defineCloudflareConfig } from '@opennextjs/cloudflare';

// Admin on Cloudflare Workers (ADR-0014). No incremental cache: every
// page reads the API at request time.
export default defineCloudflareConfig();
