// Loads apps/api/.env when present (Node 22's built-in loader); real
// environment variables always win.
try {
  process.loadEnvFile();
} catch {
  // no .env file: rely on the environment
}

/** Production must set it; dev and tests fall back to infra/docker/dev. */
function devDefault(name: string, fallback: string): string {
  const value = process.env[name];
  if (value) return value;
  if (process.env.NODE_ENV === 'production') throw new Error(`${name} is not set.`);
  return fallback;
}

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`${name} is not set. Copy .env.example to .env.`);
  return value;
}

// Getters, so each read sees the current environment (tests change it).
export const env = {
  get databaseUrl() {
    return required('DATABASE_URL');
  },
  get port() {
    return Number(process.env.PORT ?? 3300);
  },
  get production() {
    return process.env.NODE_ENV === 'production';
  },
  /** Apps older than this get 426 update_required. */
  get minAppVersion() {
    return process.env.MIN_APP_VERSION ?? '0.0.0';
  },
  get latestAppVersion() {
    return process.env.LATEST_APP_VERSION ?? '1.0.0';
  },
  get launchCity() {
    return process.env.LAUNCH_CITY ?? 'Addis Ababa';
  },
  get resendApiKey() {
    return process.env.RESEND_API_KEY ?? '';
  },
  get mailFrom() {
    return process.env.MAIL_FROM ?? 'gamer-network <no-reply@example.com>';
  },
  /** Every OAuth client id whose Google ID tokens we accept (Android, iOS, web). */
  get googleClientIds() {
    return (process.env.GOOGLE_CLIENT_IDS ?? '')
      .split(',')
      .map((id) => id.trim())
      .filter(Boolean);
  },
  /** Browser origins allowed to call the API (the PWA, the web site). */
  get webOrigins() {
    return (process.env.WEB_ORIGINS ?? 'http://localhost:3000,http://localhost:8080')
      .split(',')
      .map((o) => o.trim())
      .filter(Boolean);
  },
  // Media storage: S3-compatible. Cloudflare R2 in production, RustFS
  // from infra/docker/dev locally.
  get s3Endpoint() {
    return devDefault('S3_ENDPOINT', 'http://localhost:9470');
  },
  get s3Region() {
    return process.env.S3_REGION ?? 'auto';
  },
  get s3AccessKeyId() {
    return devDefault('S3_ACCESS_KEY_ID', 'gn-media');
  },
  get s3SecretAccessKey() {
    return devDefault('S3_SECRET_ACCESS_KEY', 'password123');
  },
  get s3Bucket() {
    return devDefault('S3_BUCKET', 'gn-media');
  },
  /** Where the bucket is publicly readable; avatar URLs start with this. */
  get mediaPublicUrl() {
    return devDefault('MEDIA_PUBLIC_URL', 'http://localhost:9470/gn-media').replace(/\/+$/, '');
  },
};
