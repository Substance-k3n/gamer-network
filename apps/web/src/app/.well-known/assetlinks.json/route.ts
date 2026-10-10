import { config } from '@/lib/config';

export const dynamic = 'force-dynamic';

/**
 * Android App Links: lets the app open https://<site>/l/<id> itself.
 * Empty until the release key's fingerprint is set (ANDROID_CERT_SHA256).
 */
export function GET() {
  const fingerprints = config.androidCertSha256;
  const body = fingerprints.length
    ? [
        {
          relation: ['delegate_permission/common.handle_all_urls'],
          target: {
            namespace: 'android_app',
            package_name: config.androidPackage,
            sha256_cert_fingerprints: fingerprints,
          },
        },
      ]
    : [];
  return Response.json(body);
}
