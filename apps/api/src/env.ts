// Loads apps/api/.env when present (Node 22's built-in loader); real
// environment variables always win.
try {
  process.loadEnvFile();
} catch {
  // no .env file: rely on the environment
}

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`${name} is not set. Copy .env.example to .env.`);
  return value;
}

export const env = {
  get databaseUrl() {
    return required('DATABASE_URL');
  },
  port: Number(process.env.PORT ?? 3300),
  production: process.env.NODE_ENV === 'production',
};
