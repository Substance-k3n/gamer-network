'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { api, type AgeRange, type Me } from '../_lib/api';
import { ageLabel } from '../_lib/data';
import { Labeled, OnboardFrame, StepHeader, titleStyle } from '../_lib/frame';
import { useApp, useUsernameNote } from '../_lib/store';
import { BigButton, Field, PasswordField, Segmented } from '../_lib/ui';

/** Sign-up, onboarding step 1 (docs/API.md "Sign-in"). */
export default function Signup() {
  const { run, busy, toast, setMe, config } = useApp();
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [handle, setHandle] = useState('');
  const [password, setPassword] = useState('');
  const [age, setAge] = useState<AgeRange>('18_24');
  const note = useUsernameNote(handle);

  const submit = async () => {
    let problem: string | null = null;
    if (!/^\S+@\S+\.\S+$/.test(email.trim())) problem = 'Enter a valid email';
    else if (!name.trim()) problem = 'Add a display name';
    else if (!handle.trim()) problem = 'Pick a username';
    else if (password.length < 8) problem = 'Password needs at least 8 characters';
    if (problem) return toast(problem);
    const r = await run(() =>
      api<{ user: Me }>('auth/signup', {
        method: 'POST',
        body: {
          email: email.trim(),
          password,
          displayName: name.trim(),
          username: handle.trim().toLowerCase(),
          ageRange: age,
        },
      }),
    );
    if (!r) return;
    setMe(r.user);
    router.replace('/app/verify');
  };

  return (
    <OnboardFrame
      onSubmit={submit}
      blob={{ left: -120, top: -60, borderRadius: '46% 54% 60% 40% / 55% 45% 55% 45%' }}
      bottom={
        <BigButton type="submit" disabled={busy}>
          {busy ? 'Creating your profile…' : 'Continue'}
        </BigButton>
      }
    >
      <StepHeader back="/app/login" fraction={0.25} label="Step 1" />
      <h1 style={titleStyle}>{'Who are you\nas a gamer?'}</h1>
      <div className="gap" style={{ gap: 10 }}>
        <Labeled label="EMAIL">
          <Field
            value={email}
            onChange={setEmail}
            placeholder="you@example.com"
            h={52}
            type="email"
            autoComplete="email"
            inputMode="email"
          />
        </Labeled>
        <Labeled label="DISPLAY NAME">
          <Field
            value={name}
            onChange={setName}
            placeholder="Kaleb"
            h={52}
            maxLength={30}
            autoComplete="nickname"
          />
        </Labeled>
        <Labeled label="USERNAME">
          <Field
            value={handle}
            onChange={setHandle}
            placeholder="kaleb.gg"
            h={52}
            maxLength={20}
            autoCapitalize="none"
            autoComplete="username"
          />
          {note && (
            <span style={{ paddingLeft: 18, fontSize: 13, fontWeight: 600, color: 'var(--acc)' }}>
              {note}
            </span>
          )}
        </Labeled>
        <Labeled label="PASSWORD">
          <PasswordField
            value={password}
            onChange={setPassword}
            placeholder="At least 8 characters"
            h={52}
            autoComplete="new-password"
          />
        </Labeled>
        <Labeled label="AGE RANGE">
          <Segmented
            options={(Object.keys(ageLabel) as AgeRange[]).map((a) => ({
              id: a,
              label: ageLabel[a],
            }))}
            value={age}
            onChange={setAge}
          />
        </Labeled>
        <div className="row" style={{ gap: 10 }}>
          <span
            style={{
              background: 'var(--soft)',
              border: '2px solid var(--line)',
              borderRadius: 99,
              padding: '6px 14px',
              fontSize: 14,
              fontWeight: 600,
            }}
          >
            Ethiopia · {config?.launchCity ?? 'Addis Ababa'}
          </span>
          <span className="muted" style={{ fontSize: 13 }}>
            Change it later in your profile
          </span>
        </div>
        <span className="muted" style={{ fontSize: 13 }}>
          rally is for players 16 and up.
        </span>
      </div>
    </OnboardFrame>
  );
}
