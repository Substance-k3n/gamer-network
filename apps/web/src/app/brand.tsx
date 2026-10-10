import Link from 'next/link';
import { BRAND } from '@/lib/config';

export function Brand() {
  return (
    <Link href="/" className="brand">
      {BRAND}
      <span>.</span>
    </Link>
  );
}

export function Footer() {
  return (
    <p className="footer">
      16+ only · <Link href="/privacy">Privacy</Link>
    </p>
  );
}
