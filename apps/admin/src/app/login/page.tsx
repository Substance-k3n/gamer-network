'use client';

import { useRouter } from 'next/navigation';
import { useEffect, useRef, useState, type CSSProperties } from 'react';
import { ACC, C1, C2, DOTO, LINE, MUT, RING, TX, grot, mono } from '@/admin/tokens';
import { Toast } from '@/admin/ui';

// From the "Dot Matrix" player login (RallyDot.dc.html), laid out for desktop.
// The admin design has no login of its own.
const field: CSSProperties = {
  height: 54,
  borderRadius: 99,
  border: `1px solid ${LINE}`,
  background: C1,
  padding: '0 20px',
  fontSize: 16,
  outline: 'none',
  color: TX,
};

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');
  const [busy, setBusy] = useState(false);
  const [toast, setToast] = useState<string | null>(null);
  const timer = useRef<ReturnType<typeof setTimeout>>(undefined);

  useEffect(() => () => clearTimeout(timer.current), []);

  const showToast = (msg: string) => {
    clearTimeout(timer.current);
    setToast(msg);
    timer.current = setTimeout(() => setToast(null), 2600);
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '48px 16px',
        boxSizing: 'border-box',
        backgroundColor: '#101010',
        backgroundImage: 'radial-gradient(rgba(255,255,255,.045) 1px,transparent 1px)',
        backgroundSize: '14px 14px',
      }}
    >
      <form
        onSubmit={async (e) => {
          e.preventDefault();
          setBusy(true);
          try {
            const res = await fetch('/api/session', {
              method: 'POST',
              headers: { 'content-type': 'application/json' },
              body: JSON.stringify({ email: email.trim(), password: pass }),
            });
            if (res.ok) {
              router.replace('/');
              router.refresh();
              return;
            }
            const body = await res.json().catch(() => null);
            showToast(body?.error?.message ?? 'Could not sign in. Try again.');
          } catch {
            showToast('Could not reach the server. Try again.');
          }
          setBusy(false);
        }}
        style={{
          width: 390,
          maxWidth: '100%',
          padding: '8px 20px 28px',
          display: 'flex',
          flexDirection: 'column',
          gap: 14,
          boxSizing: 'border-box',
          position: 'relative',
          isolation: 'isolate',
        }}
      >
        <div
          style={{
            position: 'absolute',
            zIndex: -1,
            width: 480,
            maxWidth: '120%',
            height: 360,
            background: '#1A1A1A',
            borderRadius: '55% 45% 50% 50% / 50% 55% 45% 50%',
            left: -40,
            top: -120,
          }}
        />
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
          <span style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 32, letterSpacing: -1 }}>
            rally<span style={{ color: ACC }}>.</span>
          </span>
          <span style={{ font: mono(400, 10), letterSpacing: '.06em', color: ACC }}>ADMIN</span>
        </div>
        <div
          style={{
            fontFamily: DOTO,
            fontWeight: 900,
            fontSize: 40,
            letterSpacing: -1.5,
            lineHeight: 1,
            marginTop: 18,
          }}
        >
          Welcome back.
        </div>
        <div style={{ fontSize: 15, color: MUT }}>Your squad&apos;s been busy.</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginTop: 14 }}>
          <input
            type="email"
            placeholder="Email"
            autoComplete="username"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            style={field}
          />
          <input
            type="password"
            placeholder="Password"
            autoComplete="current-password"
            required
            value={pass}
            onChange={(e) => setPass(e.target.value)}
            style={field}
          />
          <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
            <span style={{ fontSize: 13, color: MUT }}>Forgot it? Reset it in the app.</span>
          </div>
        </div>
        <button
          type="submit"
          disabled={busy}
          style={{
            marginTop: 28,
            height: 56,
            borderRadius: 99,
            background: C2,
            border: `1px solid ${LINE}`,
            boxShadow: RING,
            font: grot(700, 17),
            color: TX,
            cursor: busy ? 'wait' : 'pointer',
            opacity: busy ? 0.7 : 1,
          }}
        >
          {busy ? 'Signing in…' : 'Log in'}
        </button>
        <div style={{ textAlign: 'center', fontSize: 14, color: MUT }}>
          Admin access is invite-only.
        </div>
      </form>
      <Toast message={toast} />
    </div>
  );
}
