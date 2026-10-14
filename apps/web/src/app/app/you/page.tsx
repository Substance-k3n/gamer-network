'use client';

import { ProfileView } from '../_lib/profile';
import { useApp } from '../_lib/store';

/** You: your own profile, theme and settings (GET /me). */
export default function You() {
  const { me, refreshMe } = useApp();
  if (!me) return null;
  return <ProfileView p={{ ...me, relationship: 'self', isMe: true }} onReload={refreshMe} />;
}
