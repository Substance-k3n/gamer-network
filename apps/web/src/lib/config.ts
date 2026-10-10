// Read on the server at request time, so one build runs anywhere.
export const config = {
  get apiUrl() {
    return (process.env.API_URL ?? 'http://localhost:3300').replace(/\/+$/, '');
  },
  get siteUrl() {
    return (process.env.PUBLIC_WEB_URL ?? 'http://localhost:3000').replace(/\/+$/, '');
  },
  get androidPackage() {
    return process.env.ANDROID_PACKAGE ?? 'com.example.rally';
  },
  get androidCertSha256() {
    return (process.env.ANDROID_CERT_SHA256 ?? '')
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
  },
  get playStoreUrl() {
    return process.env.PLAY_STORE_URL || null;
  },
  get contactEmail() {
    return process.env.CONTACT_EMAIL || null;
  },
};

/** Working name; the real brand comes before the Play listing (README). */
export const BRAND = 'rally';
