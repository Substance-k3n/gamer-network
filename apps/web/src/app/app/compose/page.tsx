'use client';

import { useMemo, useState } from 'react';
import { api, uuid, type Post, type PostAudience, type PostType } from '../_lib/api';
import { postable, postTypeInfo } from '../_lib/data';
import { useApp } from '../_lib/store';
import {
  Avatar,
  Card,
  Chip,
  CircleBtn,
  Icon,
  Label,
  Pill,
  Segmented,
  TypeTag,
  toneColor,
} from '../_lib/ui';

/**
 * New post (the prototype's compose screen): type, text, game, audience.
 * Only the types the API takes today (photos, polls and recruitment wait for
 * its later phases). One Idempotency-Key per draft.
 */
export default function Compose() {
  const { me, run, busy, toast, setFeed, back } = useApp();
  const myGames = (me?.games ?? []).flatMap((g) => (g.game ? [g.game] : []));
  const [type, setType] = useState<PostType>('discussion');
  // '' is "Any game".
  const [gameId, setGameId] = useState(myGames[0]?.id ?? '');
  const [audience, setAudience] = useState<PostAudience>('everyone');
  const [text, setText] = useState('');
  const key = useMemo(() => uuid(), []);
  const info = postTypeInfo(type);
  const ready = text.trim().length > 0;
  const typeUpper = info.label.toUpperCase();

  const submit = async () => {
    if (!ready) return toast('Write something first');
    const p = await run(() =>
      api<Post>('posts', {
        method: 'POST',
        key,
        body: { type, text: text.trim(), gameId: gameId || null, audience },
      }),
    );
    if (!p) return;
    setFeed((f) => ({ ...f, posts: [p, ...f.posts.filter((x) => x.id !== p.id)] }));
    back('/app');
    toast(`${info.label} posted`);
  };

  return (
    <div className="gap rl-pad" style={{ gap: 12, paddingTop: 4, paddingBottom: 28 }}>
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
          disabled={busy}
        >
          {busy ? 'Posting…' : 'Post'}
        </Pill>
      </div>
      <Label>POST TYPE</Label>
      <div className="wrap">
        {postable.map((t) => {
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
