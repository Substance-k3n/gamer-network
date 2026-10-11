import {
  DeleteObjectCommand,
  HeadObjectCommand,
  NotFound,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { env } from '../env.js';

export const MEDIA_STORAGE = Symbol('MEDIA_STORAGE');

export interface StoredObject {
  size: number;
  contentType: string | undefined;
}

/** Where avatars live. Clients upload straight to it with a presigned URL. */
export interface MediaStorage {
  /** A URL that accepts one PUT of exactly this type and size, for `expiresIn` seconds. */
  uploadUrl(key: string, contentType: string, size: number, expiresIn: number): Promise<string>;
  /** Null when nothing is stored at `key`. */
  head(key: string): Promise<StoredObject | null>;
  delete(key: string): Promise<void>;
  publicUrl(key: string): string;
}

export class S3MediaStorage implements MediaStorage {
  private readonly s3 = new S3Client({
    endpoint: env.s3Endpoint,
    region: env.s3Region,
    credentials: { accessKeyId: env.s3AccessKeyId, secretAccessKey: env.s3SecretAccessKey },
    // RustFS (and MinIO) serve buckets as paths; R2 accepts both.
    forcePathStyle: true,
  });
  private readonly bucket = env.s3Bucket;

  uploadUrl(key: string, contentType: string, size: number, expiresIn: number) {
    const put = new PutObjectCommand({
      Bucket: this.bucket,
      Key: key,
      ContentType: contentType,
      ContentLength: size,
    });
    return getSignedUrl(this.s3, put, {
      expiresIn,
      // Signed, so the upload must send exactly these.
      signableHeaders: new Set(['content-type', 'content-length']),
    });
  }

  async head(key: string): Promise<StoredObject | null> {
    try {
      const res = await this.s3.send(new HeadObjectCommand({ Bucket: this.bucket, Key: key }));
      return { size: res.ContentLength ?? 0, contentType: res.ContentType };
    } catch (e) {
      if (e instanceof NotFound || (e as { name?: string }).name === 'NotFound') return null;
      throw e;
    }
  }

  async delete(key: string): Promise<void> {
    await this.s3.send(new DeleteObjectCommand({ Bucket: this.bucket, Key: key }));
  }

  publicUrl(key: string): string {
    return `${env.mediaPublicUrl}/${key}`;
  }
}
