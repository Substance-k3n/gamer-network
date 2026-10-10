import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import { AdminDashboard } from '@/admin/AdminDashboard';
import { SESSION_COOKIE } from '@/server/session';

export default async function Page() {
  if (!(await cookies()).get(SESSION_COOKIE)) redirect('/login');
  return <AdminDashboard />;
}
