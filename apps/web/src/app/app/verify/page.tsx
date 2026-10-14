'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { api, type Me } from '../_lib/api';
import { OnboardFrame, titleStyle } from '../_lib/frame';
import { useApp } from '../_lib/store';
import { BackBtn, BigButton, Field } from '../_lib/ui';

/** The 6-digit code from the sign-up email. "Later" lets people look around first. */
export default function Verify() {
  const { me, setMe, run, busy, toast } = useApp();
  const router = useRouter();
  const [code, setCode] = useState('');
  const next = () => router.replace(me?.onboardedAt ? '/app' : '/app/onboarding/games');

  const submit = async () => {
    if (code.trim().length < 6) return toast('Enter the 6-digit code from the email');
    const m = await run(() =>
      api<Me>('auth/verify-email', { method: 'POST', body: { code: code.trim() } }),
    );
    if (!m) return;
    setMe(m);
    toast('Email confirmed');
    next();
  };
  const resend = async () => {
    const ok = await run(() =>
      api<void>('auth/verify-email/resend', { method: 'POST' }).then(() => true),
    );
    if (ok) toast(`New code sent to ${me?.email ?? 'your email'}`);
  };

  return (
    <OnboardFrame
      gap={14}
      onSubmit={submit}
      blob={{
        left: -60,
        top: -120,
        width: 480,
        height: 360,
        borderRadius: '50% 50% 45% 55% / 55% 45% 50% 50%',
      }}
      bottom={
        <BigButton type="submit" disabled={busy}>
          {busy ? 'Checking…' : 'Confirm email'}
        </BigButton>
      }
    >
      <BackBtn onClick={next} />
      <h1 style={titleStyle}>{'Check your\ninbox.'}</h1>
      <div className="muted" style={{ fontSize: 15, lineHeight: 1.4 }}>
        We sent a 6-digit code to {me?.email ?? 'your email'}. It works for 10 minutes.
      </div>
      <Field
        value={code}
        onChange={setCode}
        placeholder="123456"
        h={56}
        inputMode="numeric"
        autoComplete="one-time-code"
        maxLength={6}
        autoFocus
      />
      <div className="row" style={{ justifyContent: 'space-between' }}>
        <button
          type="button"
          className="u"
          style={{ fontSize: 14, fontWeight: 600 }}
          onClick={resend}
          disabled={busy}
        >
          Send a new code
        </button>
        <button
          type="button"
          className="u muted"
          style={{ fontSize: 14, textDecoration: 'none' }}
          onClick={next}
        >
          Later
        </button>
      </div>
    </OnboardFrame>
  );
}
