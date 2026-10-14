'use client';

import { useMemo, useState } from 'react';
import { api, uuid, type Listing, type ReportReason } from './api';
import { reasonLabel } from './data';
import { useApp } from './store';
import { Chip, Dialog, Field, Pill, useConfirm } from './ui';

// Block and Report on every profile and listing (ADR-0005, Play policy).

export async function shareListing(l: Listing, toast: (m: string) => void) {
  try {
    if (navigator.share)
      return await navigator.share({ title: `${l.game.name} on rally`, url: l.shareUrl });
    await navigator.clipboard.writeText(l.shareUrl);
    toast('Link copied — paste it in Telegram or WhatsApp');
  } catch {}
}

/** The ⋯ menu on a profile or listing card. */
export function PlayerMenu({
  userId,
  name,
  listing,
  connected,
  onClose,
  onDone,
}: {
  userId: string;
  name: string;
  listing?: Listing;
  connected?: boolean;
  onClose: () => void;
  onDone?: (what: 'blocked' | 'removed') => void;
}) {
  const { run, toast, bump } = useApp();
  const [mode, setMode] = useState<'menu' | 'report'>('menu');
  const [ask, confirm] = useConfirm();

  const block = async () => {
    if (
      !(await ask(
        `Block ${name}?`,
        'You won’t see each other anywhere on rally. Any connection between you ends, and they aren’t told.',
        'Block',
      ))
    )
      return;
    const ok = await run(() =>
      api('blocks', { method: 'POST', body: { userId } }).then(() => true),
    );
    if (!ok) return;
    toast(`${name} is blocked. You won’t see each other.`);
    onClose();
    bump();
    onDone?.('blocked');
  };
  const remove = async () => {
    if (
      !(await ask(
        `Remove ${name}?`,
        'You stop being connected: your private gaming IDs lock again, both ways. They aren’t told.',
        'Remove',
      ))
    )
      return;
    const ok = await run(() => api(`connections/${userId}`, { method: 'DELETE' }).then(() => true));
    if (!ok) return;
    toast(`You’re no longer connected with ${name}`);
    onClose();
    onDone?.('removed');
  };

  if (confirm) return confirm;
  if (mode === 'report')
    return <ReportDialog userId={userId} name={name} listingId={listing?.id} onClose={onClose} />;
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>{name}</div>
      {listing && (
        <Pill
          h={48}
          size={15}
          bold
          expand
          look="clear"
          onClick={() => shareListing(listing, toast).then(onClose)}
        >
          Copy share link
        </Pill>
      )}
      {connected && (
        <Pill h={48} size={15} bold expand look="clear" onClick={remove}>
          Remove connection
        </Pill>
      )}
      <Pill h={48} size={15} bold expand look="clear" onClick={() => setMode('report')}>
        Report
      </Pill>
      <Pill h={48} size={15} bold expand look="strong" onClick={block}>
        Block {name}
      </Pill>
      <Pill h={44} size={14} expand look="clear" onClick={onClose} style={{ border: 0 }}>
        Cancel
      </Pill>
    </Dialog>
  );
}

function ReportDialog({
  userId,
  name,
  listingId,
  onClose,
}: {
  userId: string;
  name: string;
  listingId?: string;
  onClose: () => void;
}) {
  const { run, toast, busy } = useApp();
  const [reason, setReason] = useState<ReportReason | null>(null);
  const [details, setDetails] = useState('');
  const key = useMemo(() => uuid(), []);
  const send = async () => {
    if (!reason) return;
    const ok = await run(() =>
      api('reports', {
        method: 'POST',
        key,
        body: {
          userId,
          reason,
          ...(listingId ? { listingId } : {}),
          ...(details.trim() ? { details: details.trim() } : {}),
        },
      }).then(() => true),
    );
    if (!ok) return;
    toast('Thanks. Our team will look at it.');
    onClose();
  };
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>Report {name}</div>
      <div className="muted" style={{ fontSize: 14 }}>
        Only our team sees reports. What’s wrong?
      </div>
      <div className="wrap">
        {(Object.keys(reasonLabel) as ReportReason[]).map((r) => (
          <Chip key={r} on={reason === r} onClick={() => setReason(r)} h={36} padH={14} size={14}>
            {reasonLabel[r]}
          </Chip>
        ))}
      </div>
      <Field
        value={details}
        onChange={setDetails}
        placeholder="Anything else? (optional)"
        h={48}
        radius={16}
        sunken
        maxLength={500}
      />
      <div className="row" style={{ gap: 8 }}>
        <Pill h={46} size={15} expand look="clear" onClick={onClose}>
          Cancel
        </Pill>
        <Pill
          h={46}
          size={15}
          bold
          expand
          look={reason ? 'accent' : 'quiet'}
          onClick={send}
          disabled={!reason || busy}
        >
          Send report
        </Pill>
      </div>
    </Dialog>
  );
}
