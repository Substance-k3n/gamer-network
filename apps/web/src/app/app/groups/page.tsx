'use client';

import Link from 'next/link';
import { useState } from 'react';
import { api } from '../_lib/api';
import { Header } from '../_lib/shell';
import { useApp } from '../_lib/store';
import { Card, EmptyNote, Icon, Label, Pill } from '../_lib/ui';

/** Groups are "coming soon" in the MVP (docs/PRD.md); the waitlist says which to launch. */
export default function Groups() {
  const { run, toast, busy } = useApp();
  const [on, setOn] = useState(false);
  const join = async () => {
    const ok = await run(() =>
      api('waitlist', { method: 'POST', body: { topic: 'groups' } }).then(() => true),
    );
    if (!ok) return;
    setOn(true);
    toast('We’ll let you know when Groups open');
  };
  return (
    <>
      <Header title="Groups" />
      <div className="gap rl-pad" style={{ gap: 14 }}>
        <Card dark pad={18} radius={26}>
          <div className="gap" style={{ gap: 12 }}>
            <Label color="var(--accent-text)">COMING SOON</Label>
            <div
              className="t-display"
              style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6, lineHeight: 1.1 }}
            >
              Your squad, your game, your city or campus.
            </div>
            <div style={{ fontSize: 14, lineHeight: 1.4, opacity: 0.85 }}>
              Groups for scrims, LAN days and campus tournaments are on the way. Tap below and we’ll
              tell you the day they open.
            </div>
            <div>
              {on ? (
                <Pill h={42} padH={16} size={14} bold look="strong">
                  You’re on the list ✓
                </Pill>
              ) : (
                <Pill h={42} padH={16} size={14} bold look="accent" onClick={join} disabled={busy}>
                  <Icon name="bell" size={16} /> Notify me
                </Pill>
              )}
            </div>
          </div>
        </Card>
        <EmptyNote>Until then, Find Players is the fastest way to build your squad.</EmptyNote>
        <div style={{ textAlign: 'center' }}>
          <Link
            href="/app/find"
            className="pill"
            style={{
              height: 42,
              padding: '0 18px',
              fontSize: 14,
              fontWeight: 700,
              boxShadow: 'var(--sh3)',
            }}
          >
            Find players
          </Link>
        </div>
      </div>
    </>
  );
}
