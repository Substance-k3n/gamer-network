'use client';

import { Icon } from './icons';
import { C1, LINE, TX } from './tokens';

// The first paint is handled by the inline script in app/layout.tsx; this flips
// data-theme on <html> and remembers it (storage can be blocked, so try/catch).
function toggleTheme() {
  const root = document.documentElement;
  const next = root.dataset.theme === 'dark' ? 'light' : 'dark';
  root.dataset.theme = next;
  try {
    localStorage.setItem('gn-theme', next);
  } catch {
    /* private window or blocked storage: the choice just lasts until reload */
  }
}

export function ThemeToggle({ size = 40 }: { size?: number }) {
  return (
    <button
      type="button"
      onClick={toggleTheme}
      title="Switch light / dark"
      aria-label="Switch between light and dark mode"
      className="btn-hover"
      style={{
        width: size,
        height: size,
        borderRadius: '50%',
        border: `1px solid ${LINE}`,
        background: C1,
        color: TX,
        cursor: 'pointer',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 0,
        display: 'inline-flex',
        flex: 'none',
      }}
    >
      <span className="show-in-light">
        <Icon name="moon" size={18} />
      </span>
      <span className="show-in-dark">
        <Icon name="sun" size={18} />
      </span>
    </button>
  );
}
