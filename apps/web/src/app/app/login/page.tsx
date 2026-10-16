'use client';

import Link from 'next/link';
import { useState } from 'react';
import { api, type Me } from '../_lib/api';
import { OnboardFrame } from '../_lib/frame';
import { useApp } from '../_lib/store';
import { BackBtn, BigButton, Field, Logo, PasswordField } from '../_lib/ui';

export default function Login() {
  const { run, busy, toast, signedIn } = useApp();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const submit = async () => {
    const id = email.trim();
    if (!id) return toast('Enter your email or username');
    if (!password) return toast('Enter your password');
    // An "@" after the first character means an email; anything else is a username.
    const who = id.indexOf('@') > 0 ? { email: id } : { username: id.replace(/^@/, '') };
    const r = await run(() =>
      api<{ user: Me }>('auth/login', { method: 'POST', body: { ...who, password } }),
    );
    if (!r) return;
    if (r.user.onboardedAt) toast(`Welcome back, ${r.user.displayName}`);
    signedIn(r.user);
  };

  return (
    <OnboardFrame
      gap={14}
      onSubmit={submit}
      blob={{
        left: -40,
        top: -120,
        width: 480,
        height: 360,
        borderRadius: '55% 45% 50% 50% / 50% 55% 45% 50%',
      }}
      bottom={
        <>
          <BigButton type="submit" disabled={busy}>
            {busy ? 'Logging in…' : 'Log in'}
          </BigButton>
          <div className="muted" style={{ textAlign: 'center', fontSize: 14 }}>
            New here?{' '}
            <Link
              href="/app/signup"
              style={{ color: 'var(--text)', fontWeight: 700, textDecoration: 'underline' }}
            >
              Create a profile
            </Link>
          </div>
        </>
      }
    >
      <BackBtn href="/app/welcome" />
      <Logo size={72} />
      <h1 style={{ fontSize: 40, fontWeight: 800, letterSpacing: -1.5, lineHeight: 1, margin: 0 }}>
        Welcome back.
      </h1>
      <div className="muted" style={{ fontSize: 15 }}>
        Your squad’s been busy.
      </div>
      <Field
        value={email}
        onChange={setEmail}
        placeholder="Email or username"
        type="text"
        autoComplete="username"
        autoCapitalize="none"
      />
      <PasswordField value={password} onChange={setPassword} />
      <div style={{ textAlign: 'right' }}>
        <Link
          href={`/app/forgot${email.indexOf('@') > 0 ? `?email=${encodeURIComponent(email.trim())}` : ''}`}
          style={{ fontSize: 13, fontWeight: 600, textDecoration: 'underline' }}
        >
          Forgot password?
        </Link>
      </div>
    </OnboardFrame>
  );
}
