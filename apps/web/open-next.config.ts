import { defineCloudflareConfig } from '@opennextjs/cloudflare';

// Web on Cloudflare Workers (ADR-0014). No incremental cache: the pages
// that matter read the API at request time.
export default defineCloudflareConfig();
