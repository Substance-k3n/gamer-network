'use client';

import { useSearchParams } from 'next/navigation';
import { Suspense, useState } from 'react';
import { api, type Me } from '../_lib/api';
import { OnboardFrame, titleStyle } from '../_lib/frame';
import { useApp } from '../_lib/store';
import { BackBtn, BigButton, Field, PasswordField } from '../_lib/ui';

/** Forgot password: email → emailed code + new password → signed in. */
export default function ForgotPage() {
  return (
    <Suspense>
      <Forgot />
    </Suspense>
  );
}

function Forgot() {
  const { run, busy, toast, signedIn } = useApp();
  const [email, setEmail] = useState(useSearchParams().get('email') ?? '');
  const [sent, setSent] = useState(false);
  const [code, setCode] = useState('');
  const [password, setPassword] = useState('');

  const send = async () => {
    if (!email.includes('@')) return toast('Enter the email you signed up with');
    const ok = await run(() =>
      api<void>('auth/password/forgot', { method: 'POST', body: { email: email.trim() } }).then(
        () => true,
      ),
    );
    if (!ok) return;
    setSent(true);
    toast(`If ${email.trim()} has an account, a code is on its way`);
  };
  const reset = async () => {
    if (code.trim().length < 6) return toast('Enter the 6-digit code from the email');
    if (password.length < 8) return toast('Password needs at least 8 characters');
    const r = await run(() =>
      api<{ user: Me }>('auth/password/reset', {
        method: 'POST',
        body: { email: email.trim(), code: code.trim(), newPassword: password },
      }),
    );
    if (!r) return;
    toast('Password changed');
    signedIn(r.user);
  };

  return (
    <OnboardFrame
      gap={14}
      onSubmit={sent ? reset : send}
      blob={{
        left: -40,
        top: -120,
        width: 480,
        height: 360,
        borderRadius: '55% 45% 50% 50% / 50% 55% 45% 50%',
      }}
      bottom={
        <BigButton type="submit" disabled={busy}>
          {sent
            ? busy
              ? 'Saving…'
              : 'Set password and log in'
            : busy
              ? 'Sending…'
              : 'Email me a code'}
        </BigButton>
      }
    >
      <BackBtn href="/app/login" />
      <h1 style={titleStyle}>{sent ? 'New password.' : 'Forgot it?'}</h1>
      <div className="muted" style={{ fontSize: 15, lineHeight: 1.4 }}>
        {sent
          ? `Enter the code we emailed to ${email.trim()} and pick a new password.`
          : 'We’ll email you a code to set a new password.'}
      </div>
      <Field
        value={email}
        onChange={setEmail}
        placeholder="Email"
        type="email"
        autoComplete="username"
        inputMode="email"
      />
      {sent && (
        <>
          <Field
            value={code}
            onChange={setCode}
            placeholder="6-digit code"
            inputMode="numeric"
            autoComplete="one-time-code"
            maxLength={6}
          />
          <PasswordField
            value={password}
            onChange={setPassword}
            placeholder="New password, 8+ characters"
            autoComplete="new-password"
          />
        </>
      )}
    </OnboardFrame>
  );
}
