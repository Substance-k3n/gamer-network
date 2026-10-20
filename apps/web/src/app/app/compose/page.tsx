'use client';

import { useEffect, useMemo, useRef, useState } from 'react';
import {
  api,
  uuid,
  type PollDuration,
  type Post,
  type PostAudience,
  type PostType,
} from '../_lib/api';
import { pad2, postTypeInfo, postTypes } from '../_lib/data';
import { MAX_PHOTOS, photoTypes, resizePhoto, uploadPhoto, type Photo } from '../_lib/media';
import { useApp } from '../_lib/store';
import {
  Avatar,
  Card,
  Chip,
  CircleBtn,
  Digits,
  Icon,
  Label,
  Pill,
  Segmented,
  TypeTag,
  toneColor,
} from '../_lib/ui';

const durations: [PollDuration, string][] = [
  ['1d', '1 day'],
  ['3d', '3 days'],
  ['1w', '1 week'],
];

/**
 * New post (the prototype's compose screen): type, text, photos, a poll or
 * a recruitment box, game, audience. Photos are resized when picked and
 * uploaded on Post; one Idempotency-Key per draft, and the draft stays when
 * anything fails.
 */
export default function Compose() {
  const { me, run, busy, toast, setFeed, back } = useApp();
  const myGames = (me?.games ?? []).flatMap((g) => (g.game ? [g.game] : []));
  const [type, setType] = useState<PostType>('discussion');
  // '' is "Any game".
  const [gameId, setGameId] = useState(myGames[0]?.id ?? '');
  const [audience, setAudience] = useState<PostAudience>('everyone');
  const [text, setText] = useState('');
  const [photos, setPhotos] = useState<Photo[]>([]);
  const [options, setOptions] = useState(['', '']);
  const [duration, setDuration] = useState<PollDuration>('1d');
  const [slots, setSlots] = useState(1);
  const [roles, setRoles] = useState('');
  const [sending, setSending] = useState(false);
  const file = useRef<HTMLInputElement>(null);
  const key = useMemo(() => uuid(), []);
  const info = postTypeInfo(type);
  const typeUpper = info.label.toUpperCase();
  const filled = options.map((o) => o.trim()).filter(Boolean);
  const needPhoto = type === 'gameplay' && photos.length === 0;
  const ready = text.trim().length > 0 && !needPhoto && (type !== 'poll' || filled.length >= 2);

  // Previews are object URLs; they go with the screen.
  const shown = useRef<Photo[]>([]);
  useEffect(() => {
    shown.current = photos;
  }, [photos]);
  useEffect(() => () => shown.current.forEach((p) => URL.revokeObjectURL(p.preview)), []);

  const pick = async (files: FileList | null) => {
    const list = [...(files ?? [])].filter((f) => photoTypes.includes(f.type));
    if (file.current) file.current.value = '';
    if (!list.length) return;
    const room = MAX_PHOTOS - photos.length;
    if (list.length > room) toast('Up to 4 photos per post');
    const added: Photo[] = [];
    for (const f of list.slice(0, Math.max(0, room))) {
      try {
        const blob = await resizePhoto(f);
        added.push({ id: uuid(), blob, preview: URL.createObjectURL(blob) });
      } catch {
        toast('That photo couldn’t be read. Try another one.');
      }
    }
    setPhotos((p) => [...p, ...added].slice(0, MAX_PHOTOS));
  };
  const addPhotos = () => {
    if (photos.length >= MAX_PHOTOS) return toast('Up to 4 photos per post');
    file.current?.click();
  };
  const removePhoto = (ph: Photo) => {
    URL.revokeObjectURL(ph.preview);
    setPhotos((ps) => ps.filter((p) => p.id !== ph.id));
  };

  const submit = async () => {
    if (!text.trim()) return toast('Write something first');
    if (needPhoto) return toast('Add at least one photo to a gameplay post');
    if (type === 'poll' && filled.length < 2) return toast('Add at least two options');
    setSending(true);
    const p = await run(async () => {
      // One at a time; each upload is kept on its photo, so a retry skips it.
      const keys: string[] = [];
      for (const ph of photos) {
        ph.upload = await uploadPhoto(ph);
        keys.push(ph.upload.key);
      }
      return api<Post>('posts', {
        method: 'POST',
        key,
        body: {
          type,
          text: text.trim(),
          gameId: gameId || null,
          audience,
          ...(keys.length ? { media: keys } : {}),
          ...(type === 'poll' ? { poll: { options: filled, duration } } : {}),
          ...(type === 'recruitment'
            ? { recruit: { slots, ...(roles.trim() ? { roles: roles.trim() } : {}) } }
            : {}),
        },
      });
    });
    setSending(false);
    if (!p) return;
    setFeed((f) => ({ ...f, posts: [p, ...f.posts.filter((x) => x.id !== p.id)] }));
    back('/app');
    toast(`${info.label} posted`);
  };

  return (
    <div className="gap rl-pad" style={{ gap: 12, paddingTop: 4, paddingBottom: 28 }}>
      <input
        ref={file}
        type="file"
        accept={photoTypes.join(',')}
        multiple
        hidden
        onChange={(e) => pick(e.target.files)}
      />
      <div className="row" style={{ justifyContent: 'space-between', gap: 8 }}>
        <CircleBtn onClick={() => back('/app')} label="Close">
          <Icon name="close" size={18} />
        </CircleBtn>
        <h1 style={{ margin: 0, fontSize: 20, fontWeight: 800, letterSpacing: -0.5 }}>New post</h1>
        <Pill
          h={42}
          padH={20}
          size={15}
          bold
          look={ready ? 'accent' : 'quiet'}
          shadow={3}
          onClick={submit}
          disabled={busy || sending}
        >
          {sending ? 'Posting…' : 'Post'}
        </Pill>
      </div>
      <Label>POST TYPE</Label>
      <div className="wrap">
        {postTypes.map((t) => {
          const on = type === t.id;
          return (
            <Chip key={t.id} on={on} onClick={() => setType(t.id)} padH={12}>
              <span className="row" style={{ gap: 6 }}>
                <i
                  style={{
                    width: 8,
                    height: 8,
                    borderRadius: '50%',
                    background: toneColor(t.tone),
                    border: `1.5px solid ${on ? 'var(--chip-on-fg)' : 'var(--text)'}`,
                  }}
                />
                {t.label}
              </span>
            </Chip>
          );
        })}
      </div>
      <Card pad="12px 14px">
        <div className="gap" style={{ gap: 10 }}>
          <div className="row" style={{ gap: 10 }}>
            <Avatar name={me?.displayName ?? '?'} tone="accent" url={me?.avatarUrl} size={38} />
            <div className="grow">
              <div className="ellipsis" style={{ fontSize: 15, fontWeight: 700 }}>
                {me?.displayName}
              </div>
              <Label>
                {typeUpper} · {audience === 'everyone' ? 'EVERYONE' : 'CONNECTIONS'}
              </Label>
            </div>
            <TypeTag bg={toneColor(info.tone)}>{typeUpper}</TypeTag>
          </div>
          <textarea
            value={text}
            onChange={(e) => setText(e.target.value.slice(0, 2000))}
            placeholder={info.placeholder}
            rows={5}
            aria-label="Post text"
            autoFocus
            style={{
              minHeight: 110,
              border: 0,
              outline: 0,
              resize: 'none',
              background: 'transparent',
              color: 'var(--text)',
              font: 'inherit',
              fontSize: 17,
              lineHeight: 1.4,
            }}
          />
          {type === 'poll' && (
            <PollEditor
              options={options}
              onOptions={setOptions}
              duration={duration}
              onDuration={setDuration}
            />
          )}
          {type === 'recruitment' && (
            <RecruitEditor slots={slots} onSlots={setSlots} roles={roles} onRoles={setRoles} />
          )}
          {photos.length > 0 ? (
            <div
              style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 6 }}
            >
              {photos.map((ph) => (
                <div
                  key={ph.id}
                  style={{
                    position: 'relative',
                    aspectRatio: '1',
                    overflow: 'hidden',
                    background: 'var(--dark)',
                    border: 'var(--line-w) solid var(--line)',
                    borderRadius: 14,
                  }}
                >
                  {/* eslint-disable-next-line @next/next/no-img-element -- a local preview */}
                  <img
                    src={ph.preview}
                    alt=""
                    style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
                  />
                  <span style={{ position: 'absolute', top: 5, right: 5 }}>
                    <CircleBtn size={24} onClick={() => removePhoto(ph)} label="Remove photo">
                      <Icon name="close" size={12} />
                    </CircleBtn>
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <button
              type="button"
              className="dashed row"
              onClick={addPhotos}
              style={{
                borderRadius: 16,
                padding: 16,
                gap: 12,
                background: 'transparent',
                textAlign: 'left',
                cursor: 'pointer',
              }}
            >
              <span
                className="row"
                style={{
                  width: 40,
                  height: 40,
                  flex: 'none',
                  justifyContent: 'center',
                  borderRadius: 12,
                  background: 'var(--dark)',
                  color: 'var(--on-dark)',
                }}
              >
                <Icon name="image" size={20} />
              </span>
              <span className="grow">
                <b style={{ display: 'block', fontSize: 14 }}>Add photos</b>
                <span className="muted" style={{ fontSize: 12 }}>
                  Up to 4 photos
                </span>
              </span>
            </button>
          )}
          {needPhoto && (
            <div className="muted" style={{ fontSize: 12 }}>
              A gameplay post needs at least one photo.
            </div>
          )}
          <div
            className="row"
            style={{ gap: 8, paddingTop: 10, borderTop: 'var(--line-w) solid var(--line)' }}
          >
            <Pill padH={12} look="clear" onClick={addPhotos}>
              <Icon name="image" size={15} /> Media
            </Pill>
            <Pill padH={12} look="clear" onClick={() => setType('poll')}>
              Poll
            </Pill>
            <span className="grow" />
            <Digits size={10} color="var(--muted)">
              {pad2(photos.length)}/04
            </Digits>
          </div>
        </div>
      </Card>
      <Label>GAME</Label>
      <div className="scroller">
        {myGames.map((g) => (
          <Chip key={g.id} on={gameId === g.id} onClick={() => setGameId(g.id)}>
            {g.name}
          </Chip>
        ))}
        <Chip on={gameId === ''} onClick={() => setGameId('')}>
          Any game
        </Chip>
      </div>
      <Label>WHO CAN SEE THIS</Label>
      <Segmented
        options={[
          { id: 'everyone', label: 'Everyone' },
          { id: 'connections', label: 'Connections' },
        ]}
        value={audience}
        onChange={setAudience}
      />
    </div>
  );
}

function PollEditor({
  options,
  onOptions,
  duration,
  onDuration,
}: {
  options: string[];
  onOptions: (o: string[]) => void;
  duration: PollDuration;
  onDuration: (d: PollDuration) => void;
}) {
  return (
    <div className="gap" style={{ gap: 7 }}>
      {options.map((o, i) => (
        <div
          key={i}
          className="row"
          style={{
            height: 44,
            padding: '0 6px 0 12px',
            gap: 6,
            background: 'var(--sunken)',
            border: 'var(--line-w) solid var(--line)',
            borderRadius: 14,
          }}
        >
          <span style={{ width: 22, flex: 'none' }}>
            <Digits size={10}>{pad2(i + 1)}</Digits>
          </span>
          <input
            className="grow"
            value={o}
            onChange={(e) =>
              onOptions(options.map((x, j) => (j === i ? e.target.value.slice(0, 60) : x)))
            }
            placeholder={`Option ${i + 1}`}
            aria-label={`Option ${i + 1}`}
            style={{
              border: 0,
              outline: 0,
              background: 'transparent',
              color: 'var(--text)',
              font: 'inherit',
              fontSize: 16,
              minWidth: 0,
            }}
          />
          {options.length > 2 && (
            <CircleBtn
              size={28}
              onClick={() => onOptions(options.filter((_, j) => j !== i))}
              label={`Remove option ${i + 1}`}
            >
              <Icon name="close" size={13} />
            </CircleBtn>
          )}
        </div>
      ))}
      {options.length < 4 && (
        <button
          type="button"
          className="dashed"
          onClick={() => onOptions([...options, ''])}
          style={{
            height: 40,
            borderRadius: 14,
            background: 'transparent',
            fontSize: 14,
            fontWeight: 600,
            cursor: 'pointer',
          }}
        >
          + Add option
        </button>
      )}
      <div className="wrap" style={{ alignItems: 'center' }}>
        <Label style={{ marginRight: 4 }}>POLL ENDS IN</Label>
        {durations.map(([d, label]) => (
          <Chip
            key={d}
            on={duration === d}
            onClick={() => onDuration(d)}
            h={30}
            padH={11}
            size={12}
          >
            {label}
          </Chip>
        ))}
      </div>
    </div>
  );
}

function RecruitEditor({
  slots,
  onSlots,
  roles,
  onRoles,
}: {
  slots: number;
  onSlots: (n: number) => void;
  roles: string;
  onRoles: (r: string) => void;
}) {
  const many = slots >= 4;
  return (
    <div
      className="gap"
      style={{
        gap: 8,
        padding: '10px 12px',
        background: 'var(--soft)',
        border: 'var(--line-w) solid var(--line)',
        borderRadius: 16,
      }}
    >
      <div className="wrap" style={{ alignItems: 'center' }}>
        <Label color="var(--text)" style={{ marginRight: 4 }}>
          SLOTS OPEN
        </Label>
        {[1, 2, 3].map((n) => (
          <Chip key={n} on={slots === n} onClick={() => onSlots(n)} h={30} padH={10}>
            <span style={{ minWidth: 14 }}>{n}</span>
          </Chip>
        ))}
        <Chip on={many} onClick={() => onSlots(many ? slots : 4)} h={30} padH={10}>
          4+
        </Chip>
      </div>
      {many && (
        <div className="row" style={{ gap: 8 }}>
          <CircleBtn size={32} onClick={() => onSlots(Math.max(4, slots - 1))} label="Fewer slots">
            <b style={{ fontSize: 16, lineHeight: 1 }}>−</b>
          </CircleBtn>
          <Digits size={16}>{pad2(slots)}</Digits>
          <CircleBtn size={32} onClick={() => onSlots(Math.min(10, slots + 1))} label="More slots">
            <Icon name="plus" size={14} />
          </CircleBtn>
          <span className="muted" style={{ fontSize: 12 }}>
            Up to 10
          </span>
        </div>
      )}
      <label className="field" style={{ height: 40, borderRadius: 12, padding: '0 12px' }}>
        <input
          value={roles}
          onChange={(e) => onRoles(e.target.value.slice(0, 80))}
          maxLength={80}
          placeholder="Roles needed — e.g. Sniper, Support"
          aria-label="Roles needed"
        />
      </label>
    </div>
  );
}
