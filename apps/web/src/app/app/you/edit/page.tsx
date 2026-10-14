'use client';

import { useRouter } from 'next/navigation';
import { useMemo, useState } from 'react';
import { api, type AgeRange, type Me } from '../../_lib/api';
import { ageLabel } from '../../_lib/data';
import {
  draftFrom,
  gameInputs,
  GamePicker,
  IdRows,
  idInputs,
  PlatformChips,
  RankCard,
  sameDraft,
  TagChips,
  useGameOf,
  type GamerDraft,
} from '../../_lib/gamer';
import { useApp, useUsernameNote } from '../../_lib/store';
import {
  Avatar,
  Card,
  Field,
  Icon,
  Label,
  Pill,
  Segmented,
  Sheet,
  TextArea,
  useConfirm,
} from '../../_lib/ui';

/** Edit profile: details, games with ranks, platforms, play style, gaming IDs. */
export default function EditProfile() {
  const { me } = useApp();
  if (!me) return null;
  return <Editor me={me} />;
}

function Editor({ me }: { me: Me }) {
  const { run, busy, toast, setMe } = useApp();
  const router = useRouter();
  const gameOf = useGameOf();
  const saved = useMemo(() => draftFrom(me), [me]);
  const [d, setD] = useState<GamerDraft>(saved);
  const [name, setName] = useState(me.displayName);
  const [handle, setHandle] = useState(me.username);
  const [bio, setBio] = useState(me.bio ?? '');
  const [city, setCity] = useState(me.city);
  const [age, setAge] = useState<AgeRange>(me.ageRange);
  const [picking, setPicking] = useState(false);
  const [ask, confirm] = useConfirm();
  const note = useUsernameNote(handle, me.username);
  const dirty =
    name !== me.displayName ||
    handle !== me.username ||
    bio !== (me.bio ?? '') ||
    city !== me.city ||
    age !== me.ageRange ||
    !sameDraft(d, saved);

  const close = async () => {
    if (
      dirty &&
      !(await ask(
        'Discard changes?',
        'Your edits to this profile won’t be saved.',
        'Discard',
        'Keep editing',
      ))
    )
      return;
    router.push('/app/you');
  };
  const save = async () => {
    if (!name.trim() || !handle.trim()) return toast('Name and username can’t be empty');
    if (!d.games.length) return toast('Keep at least one game');
    const m = await run(async () => {
      const patch: Record<string, unknown> = {};
      if (name.trim() !== me.displayName) patch.displayName = name.trim();
      if (handle.trim().toLowerCase() !== me.username) patch.username = handle.trim().toLowerCase();
      if (bio.trim() !== (me.bio ?? '')) patch.bio = bio.trim();
      if (city.trim() && city.trim() !== me.city) patch.city = city.trim();
      if (age !== me.ageRange) patch.ageRange = age;
      await api('me', { method: 'PATCH', body: patch });
      await api('me/games', { method: 'PUT', body: { games: gameInputs(d, gameOf) } });
      await api('me/platforms', { method: 'PUT', body: { platforms: d.platforms } });
      await api('me/tags', { method: 'PUT', body: { tags: d.tags } });
      await api('me/gaming-ids', { method: 'PUT', body: { gamingIds: idInputs(d, gameOf) } });
      return api<Me>('me');
    });
    if (!m) return;
    setMe(m);
    toast('Profile updated');
    router.push('/app/you');
  };
  const removePhoto = async () => {
    const m = await run(() => api<Me>('me/avatar', { method: 'DELETE' }));
    if (!m) return;
    setMe(m);
    toast('Photo removed');
  };

  const labeled = (label: string, child: React.ReactNode) => (
    <div className="gap" style={{ gap: 6 }}>
      <Label style={{ paddingLeft: 14 }}>{label}</Label>
      {child}
    </div>
  );

  return (
    <div className="gap" style={{ minHeight: '100dvh' }}>
      <div
        className="row"
        style={{
          padding: '4px 16px 10px',
          gap: 8,
          position: 'sticky',
          top: 0,
          background: 'var(--bg)',
          zIndex: 3,
        }}
      >
        <button
          type="button"
          className="circle"
          style={{ width: 44, height: 44, fontSize: 18 }}
          onClick={close}
          aria-label="Close"
        >
          ×
        </button>
        <h1
          className="grow"
          style={{
            margin: 0,
            textAlign: 'center',
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: -0.5,
          }}
        >
          Edit profile
        </h1>
        <Pill
          h={42}
          padH={20}
          size={15}
          bold
          look={dirty ? 'accent' : 'quiet'}
          shadow={3}
          onClick={save}
          disabled={busy}
        >
          {busy ? 'Saving…' : 'Save'}
        </Pill>
      </div>
      <div className="gap" style={{ gap: 14, padding: '4px 16px 40px' }}>
        <Card pad={14}>
          <div className="row" style={{ gap: 14 }}>
            <Avatar name={name} tone="accent" url={me.avatarUrl} size={60} />
            <div className="grow">
              <div
                className="ellipsis"
                style={{ fontSize: 20, fontWeight: 800, letterSpacing: -0.5 }}
              >
                {name || 'Your name'}
              </div>
              <div className="muted ellipsis" style={{ fontSize: 13 }}>
                @{handle} · {city}
              </div>
              {me.avatarUrl && (
                <button
                  type="button"
                  className="u muted"
                  style={{ fontSize: 13, marginTop: 4 }}
                  onClick={removePhoto}
                  disabled={busy}
                >
                  Remove photo
                </button>
              )}
            </div>
          </div>
        </Card>
        {labeled(
          'DISPLAY NAME',
          <Field value={name} onChange={setName} placeholder="Kaleb" h={50} maxLength={30} />,
        )}
        {labeled(
          'USERNAME',
          <>
            <Field
              value={handle}
              onChange={setHandle}
              placeholder="kaleb.gg"
              h={50}
              maxLength={20}
              autoCapitalize="none"
              leading={<span className="muted">@</span>}
            />
            {note && (
              <span style={{ paddingLeft: 14, fontSize: 13, fontWeight: 600, color: 'var(--acc)' }}>
                {note}
              </span>
            )}
          </>,
        )}
        {labeled(
          'BIO',
          <TextArea
            value={bio}
            onChange={setBio}
            placeholder="What do you play, and who are you looking for?"
          />,
        )}
        {labeled(
          'CITY',
          <Field value={city} onChange={setCity} placeholder="Addis Ababa" h={50} maxLength={60} />,
        )}
        {labeled(
          'AGE RANGE',
          <Segmented
            options={(Object.keys(ageLabel) as AgeRange[]).map((a) => ({
              id: a,
              label: ageLabel[a],
            }))}
            value={age}
            onChange={setAge}
          />,
        )}
        <div className="row" style={{ padding: '4px 6px 0' }}>
          <Label>GAMES & RANKS</Label>
          <span className="grow" />
          <Label>{d.games.length} GAMES</Label>
        </div>
        {d.games.map((k) => (
          <RankCard
            key={k}
            game={gameOf(d, k)}
            rank={d.ranks[k]}
            role={d.roles[k]}
            onRank={(r) => setD({ ...d, ranks: { ...d.ranks, [k]: r } })}
            onRole={(r) => setD({ ...d, roles: { ...d.roles, [k]: r } })}
            onRemove={() => {
              const { [k]: _r, ...ranks } = d.ranks;
              const { [k]: _o, ...roles } = d.roles;
              setD({ ...d, games: d.games.filter((x) => x !== k), ranks, roles });
            }}
          />
        ))}
        <button
          type="button"
          className="dashed row"
          style={{
            height: 52,
            justifyContent: 'center',
            gap: 8,
            background: 'transparent',
            cursor: 'pointer',
            fontSize: 15,
            fontWeight: 700,
          }}
          onClick={() => setPicking(true)}
        >
          <Icon name="plus" size={18} /> Add or change games
        </button>
        <Label style={{ paddingLeft: 6, marginTop: 4 }}>PLATFORMS</Label>
        <PlatformChips value={d.platforms} onChange={(platforms) => setD({ ...d, platforms })} />
        <Label style={{ paddingLeft: 6, marginTop: 4 }}>PLAY STYLE · UP TO 6</Label>
        <TagChips value={d.tags} onChange={(tags) => setD({ ...d, tags })} />
        <Label style={{ paddingLeft: 6, marginTop: 4 }}>
          GAMING IDS · YOU CHOOSE WHO SEES THEM
        </Label>
        <IdRows draft={d} onChange={setD} />
      </div>
      {picking && (
        <Sheet onClose={() => setPicking(false)}>
          <div className="row" style={{ marginBottom: 12 }}>
            <div className="grow" style={{ fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>
              Your games
            </div>
            <Pill
              h={40}
              padH={18}
              size={15}
              bold
              look="accent"
              shadow={3}
              onClick={() => setPicking(false)}
            >
              Done
            </Pill>
          </div>
          <GamePicker draft={d} onChange={setD} height="65dvh" />
        </Sheet>
      )}
      {confirm}
    </div>
  );
}
