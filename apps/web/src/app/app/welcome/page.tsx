'use client';

import Link from 'next/link';
import { useState } from 'react';
import { intros } from '../_lib/data';
import { Avatar, Card, Digits, Dot, Label, Pill, Progress, Wordmark } from '../_lib/ui';

const blobs = [
  { left: -150, top: 90, r: '48% 52% 60% 40% / 55% 45% 55% 45%' },
  { left: -20, top: 60, r: '60% 40% 42% 58% / 48% 62% 38% 52%' },
  { left: -110, top: 120, r: '42% 58% 55% 45% / 60% 40% 60% 40%' },
];

/** The three-step intro, then Log in (prototype "Landing"). */
export default function Welcome() {
  const [i, setI] = useState(0);
  const intro = intros[i]!;
  const b = blobs[i]!;
  return (
    <div
      style={{
        position: 'relative',
        minHeight: '100dvh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <div
        className="blob"
        style={{ width: 520, height: 440, left: b.left, top: b.top, borderRadius: b.r }}
      />
      <div className="over gap grow" style={{ padding: '8px 24px 12px', alignItems: 'center' }}>
        <div className="row" style={{ width: '100%', justifyContent: 'space-between' }}>
          <Wordmark />
          <Link
            href="/app/login"
            style={{ fontSize: 14, fontWeight: 600, textDecoration: 'underline' }}
          >
            Log in
          </Link>
        </div>
        <div
          style={{
            minHeight: 50,
            marginTop: 26,
            fontSize: 20,
            fontWeight: 700,
            lineHeight: 1.25,
            textAlign: 'center',
          }}
        >
          {intro.kicker}
        </div>
        <div
          style={{ height: 380, width: 342, maxWidth: '100%', position: 'relative', marginTop: 4 }}
          key={i}
        >
          {i === 0 ? <IntroId /> : i === 1 ? <IntroFind /> : <IntroConnect />}
        </div>
        <div style={{ textAlign: 'center', marginTop: 6 }}>
          <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: -0.6 }}>{intro.step}</div>
          <p
            className="muted"
            style={{ maxWidth: 290, margin: '8px auto 0', fontSize: 15, lineHeight: 1.45 }}
          >
            {intro.body}
          </p>
        </div>
      </div>
      <div className="over" style={{ padding: '4px 24px 30px' }}>
        {i < 2 ? (
          <div className="row" style={{ justifyContent: 'space-between' }}>
            <button
              type="button"
              className="u"
              style={{
                width: 60,
                textAlign: 'left',
                textDecoration: 'none',
                color: 'var(--faint)',
                fontSize: 14,
              }}
              onClick={() => setI(2)}
            >
              Skip
            </button>
            <Progress value={(i + 1) / 3} />
            <button
              type="button"
              className="u"
              style={{
                width: 60,
                textAlign: 'right',
                textDecoration: 'none',
                fontSize: 15,
                fontWeight: 700,
              }}
              onClick={() => setI(i + 1)}
            >
              Next
            </button>
          </div>
        ) : (
          <div className="gap" style={{ alignItems: 'center', gap: 12 }}>
            <Link
              href="/app/login"
              className="pill ink"
              style={{
                height: 46,
                padding: '0 34px',
                fontSize: 15,
                fontWeight: 700,
                boxShadow: 'var(--glow)',
              }}
            >
              Start
            </Link>
            <button
              type="button"
              className="u"
              style={{ textDecoration: 'none', color: 'var(--faint)', fontSize: 13 }}
              onClick={() => setI(1)}
            >
              Back
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

const tilt = (deg: number) => ({ transform: `rotate(${deg}deg)` });
const abs = (left: number | string, top: number, width?: number) => ({
  position: 'absolute' as const,
  left,
  top,
  width,
});

function IntroId() {
  const row = (g: string, r: string) => (
    <div
      className="row"
      style={{
        justifyContent: 'space-between',
        border: '1.5px solid rgba(247,245,241,.4)',
        borderRadius: 12,
        padding: '7px 10px',
        fontSize: 13,
      }}
    >
      <b>{g}</b>
      <span>{r}</span>
    </div>
  );
  return (
    <>
      <div style={{ ...abs(34, 24, 232), ...tilt(-5) }}>
        <Card dark pad={16} radius={26} style={{ boxShadow: 'var(--sh6)' }}>
          <div className="row" style={{ gap: 10, marginBottom: 14 }}>
            <Avatar name="Kaleb" tone="accent" size={48} onDark />
            <div>
              <div style={{ fontSize: 19, fontWeight: 800 }}>Kaleb</div>
              <Label size={8} color="var(--accent-text)">
                GAMER ID
              </Label>
            </div>
          </div>
          <div className="gap" style={{ gap: 6 }}>
            {row('Valorant', 'Gold · Duelist')}
            {row('EA FC 25', 'Div 3')}
          </div>
          <div className="row" style={{ gap: 5, marginTop: 10 }}>
            {['PC', 'PS5'].map((x) => (
              <span
                key={x}
                style={{
                  background: 'var(--surface)',
                  color: 'var(--text)',
                  borderRadius: 99,
                  padding: '3px 9px',
                  fontSize: 11,
                  fontWeight: 700,
                }}
              >
                {x}
              </span>
            ))}
            <span
              style={{
                border: '1.5px solid var(--on-dark-line)',
                borderRadius: 99,
                padding: '2px 9px',
                fontSize: 11,
                fontWeight: 600,
              }}
            >
              Competitive
            </span>
          </div>
        </Card>
      </div>
      <div style={{ ...abs('auto', 250), right: 6, ...tilt(6) }}>
        <Card pad="9px 14px" radius={99} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <Dot color="var(--accent)" />
          <b style={{ fontSize: 14 }}>Looking for players</b>
        </Card>
      </div>
      <div style={{ ...abs(12, 300), ...tilt(-3) }}>
        <Card flat pad="6px 10px" radius={14}>
          <Label size={9}>RIOT ID · kaleb#ADD</Label>
        </Card>
      </div>
    </>
  );
}

function IntroFind() {
  return (
    <>
      <div style={{ ...abs(52, 14, 220), height: 200, ...tilt(-7), opacity: 0.9 }}>
        <Card flat style={{ height: '100%' }}>
          {null}
        </Card>
      </div>
      <div style={{ ...abs(30, 40, 252), ...tilt(3) }}>
        <Card pad={14} style={{ boxShadow: 'var(--sh6)' }}>
          <div className="gap" style={{ gap: 9 }}>
            <div className="row" style={{ gap: 9 }}>
              <Avatar name="Dave" tone="soft" size={38} />
              <div className="grow">
                <div style={{ fontSize: 15, fontWeight: 700 }}>Dave</div>
                <div className="muted" style={{ fontSize: 11 }}>
                  Addis Ababa · PC
                </div>
              </div>
              <Digits size={11}>02:14:09</Digits>
            </div>
            <div className="row" style={{ gap: 6, alignItems: 'stretch' }}>
              <Card dark flat pad="8px 10px" radius={14} style={{ flex: 1 }}>
                <Label size={8} color="var(--accent-text)">
                  RANKED
                </Label>
                <div style={{ fontSize: 15, fontWeight: 700 }}>Valorant</div>
                <div style={{ fontSize: 12, opacity: 0.85 }}>Diamond</div>
              </Card>
              <Card
                flat
                radius={14}
                pad={0}
                style={{
                  width: 70,
                  background: 'var(--soft)',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <Label size={8}>NEED</Label>
                <div style={{ fontSize: 17, fontWeight: 800 }}>Duo</div>
              </Card>
            </div>
            <div style={{ fontSize: 13 }}>“Looking for a ranked duo tonight.”</div>
            <Pill h={36} size={14} bold look="accent" expand>
              Connect
            </Pill>
          </div>
        </Card>
      </div>
      <div className="row" style={{ ...abs('auto', 282), right: 10, gap: 6, ...tilt(-4) }}>
        <Pill h={30} padH={12} size={12} look="ink" style={{ border: 0 }}>
          Mic on
        </Pill>
        <Pill h={30} padH={12} size={12}>
          Tonight
        </Pill>
      </div>
    </>
  );
}

function IntroConnect() {
  return (
    <>
      <div className="row" style={{ ...abs(40, 40) }}>
        <span style={tilt(-6)}>
          <Avatar name="Kaleb" tone="accent" size={86} />
        </span>
        <span style={{ width: 70, borderTop: '3px dashed var(--line)' }} />
        <span style={tilt(6)}>
          <Avatar name="Dave" tone="lav" size={86} />
        </span>
      </div>
      <div style={{ ...abs(106, 142), ...tilt(-3) }}>
        <Card pad="7px 14px" radius={99} style={{ boxShadow: 'var(--sh3)' }}>
          <b style={{ fontSize: 14 }}>Connected ✓</b>
        </Card>
      </div>
      <div style={{ ...abs(46, 206, 250), ...tilt(2) }}>
        <Card dark pad="14px 16px" style={{ boxShadow: 'var(--sh6)' }}>
          <div className="row" style={{ gap: 12 }}>
            <div className="grow">
              <Label size={8} color="var(--accent-text)">
                SESSION
              </Label>
              <div style={{ fontSize: 16, fontWeight: 700, marginTop: 3 }}>
                Valorant · Ranked duo
              </div>
            </div>
            <Digits size={20}>21:00</Digits>
          </div>
        </Card>
      </div>
    </>
  );
}
