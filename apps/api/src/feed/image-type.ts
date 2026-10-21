// docs/FEED_AND_GROUPS_API.md "Media uploads": what an upload really is, from
// its first bytes, so a file signed as an image can't be something else.

/** How many leading bytes imageTypeOf needs. */
export const SNIFF_BYTES = 12;

/** image/jpeg, image/png or image/webp when the bytes start like one, else null. */
export function imageTypeOf(bytes: Uint8Array): 'image/jpeg' | 'image/png' | 'image/webp' | null {
  const at = (i: number, ...want: number[]) => want.every((b, j) => bytes[i + j] === b);
  if (at(0, 0xff, 0xd8, 0xff)) return 'image/jpeg';
  if (at(0, 0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)) return 'image/png';
  // RIFF <size> WEBP
  if (at(0, 0x52, 0x49, 0x46, 0x46) && at(8, 0x57, 0x45, 0x42, 0x50)) return 'image/webp';
  return null;
}
