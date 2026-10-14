'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { api, uuid, type Listing } from './api';
import { countdown, partyLabel, platformLabel, playWhenLabel, toneFor } from './data';
import { PlayerMenu } from './safety';
import { useApp, useNow } from './store';
import { Avatar, Card, Digits, Dot, Icon, Label, Pill, useConfirm } from './ui';

/** A "Looking for players" listing: owner, game, need, tags, note, Connect. */
export function ListingCard({ l, onChanged }: { l: Listing; onChanged: () => void }) {
  const { me, run, toast, busy } = useApp();
  const router = useRouter();
  const now = useNow();
  const [menu, setMenu] = useState(false);
  const [ask, confirm] = useConfirm();
  const o = l.owner;
  const mine = o.id === me?.id;
  const need = l.partySize - 1 - l.filled;
  const req = l.myRequest;
  const look = mine
    ? { label: 'Your listing', cls: 'quiet' as const }
    : req?.status === 'accepted'
      ? { label: 'Connected ✓', cls: 'strong' as const }
      : req?.status === 'pending'
        ? { label: 'Requested…', cls: 'quiet' as const }
        : { label: 'Connect', cls: 'accent' as const };
  const open = () => router.push(`/app/players/${o.username}`);

  const act = async () => {
    if (mine) return;
    if (!req) {
      const r = await run(() =>
        api('connection-requests', {
          method: 'POST',
          key: uuid(),
          body: { toUserId: o.id, listingId: l.id },
        }),
      );
      if (r === null) return;
      toast(`Request sent to ${o.displayName}`);
      onChanged();
    } else if (req.status === 'pending') {
      if (
        !(await ask(
          'Withdraw your request?',
          `${o.displayName} won’t see it any more. You can ask again later.`,
          'Withdraw',
          'Keep it',
        ))
      )
        return;
      const ok = await run(() =>
        api(`connection-requests/${req.id}`, { method: 'DELETE' }).then(() => true),
      );
      if (!ok) return;
      toast(`Request to ${o.displayName} withdrawn`);
      onChanged();
    }
  };

  return (
    <Card pad={14}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 10 }}>
          <span style={{ position: 'relative' }}>
            <Avatar
              name={o.displayName}
              tone={toneFor(o.id)}
              url={o.avatarUrl}
              size={44}
              onClick={open}
            />
            <span style={{ position: 'absolute', right: -2, bottom: -2 }}>
              <Dot color="var(--accent)" size={12} />
            </span>
          </span>
          <div className="grow">
            <button
              type="button"
              className="u"
              style={{ textDecoration: 'none', fontSize: 16, fontWeight: 700 }}
              onClick={open}
            >
              {o.displayName}
            </button>
            <div className="muted" style={{ fontSize: 12 }}>
              {o.city} · {platformLabel[l.platform]}
            </div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <Label size={8}>EXPIRES IN</Label>
            <div style={{ marginTop: 3 }}>
              <Digits>{countdown(l.expiresAt, now)}</Digits>
            </div>
          </div>
          {!mine && (
            <button
              type="button"
              className="u"
              style={{ display: 'flex', padding: '8px 4px' }}
              aria-label={`More for ${o.displayName}`}
              onClick={() => setMenu(true)}
            >
              <Icon name="more" />
            </button>
          )}
        </div>
        <div className="row" style={{ gap: 8, alignItems: 'stretch' }}>
          <Card dark flat pad="10px 12px" radius={16} style={{ flex: 1 }}>
            <Label size={9} color="var(--accent-text)">
              {(
                l.mode?.name ?? (l.style === 'competitive' ? 'Competitive' : 'Casual')
              ).toUpperCase()}
            </Label>
            <div style={{ fontSize: 17, fontWeight: 700, marginTop: 2 }}>{l.game.name}</div>
            <div style={{ fontSize: 13, opacity: 0.85 }}>{l.rank?.name ?? 'Any rank'}</div>
          </Card>
          <div
            className="gap"
            style={{
              width: 86,
              background: 'var(--soft)',
              border: 'var(--line-w) solid var(--line)',
              borderRadius: 16,
              alignItems: 'center',
              justifyContent: 'center',
              padding: 4,
            }}
          >
            <Label>NEED</Label>
            <div
              style={{ fontSize: 20, fontWeight: 800, letterSpacing: -0.5, textAlign: 'center' }}
            >
              {l.filled === 0 ? partyLabel(l.partySize) : `${need} more`}
            </div>
          </div>
        </div>
        <div className="wrap">
          {[
            l.voice === 'required' ? 'Mic required' : 'Mic optional',
            playWhenLabel[l.playWhen],
            platformLabel[l.platform],
          ].map((t) => (
            <span key={t} className="tag">
              {t}
            </span>
          ))}
        </div>
        {l.note && <div style={{ fontSize: 15, lineHeight: 1.35 }}>“{l.note}”</div>}
        <div className="row" style={{ gap: 8 }}>
          <Pill h={44} padH={16} size={14} look="clear" onClick={open}>
            Profile
          </Pill>
          <Pill
            h={44}
            size={15}
            bold
            expand
            look={look.cls}
            shadow={3}
            onClick={act}
            disabled={busy || mine || req?.status === 'accepted'}
          >
            {look.label}
          </Pill>
        </div>
      </div>
      {menu && (
        <PlayerMenu
          userId={o.id}
          name={o.displayName}
          listing={l}
          onClose={() => setMenu(false)}
          onDone={onChanged}
        />
      )}
      {confirm}
    </Card>
  );
}
