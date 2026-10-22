import { imageTypeOf } from './image-type.js';

const bytes = (...b: number[]) => Uint8Array.from(b);

describe('imageTypeOf', () => {
  it('knows JPEG, PNG and WebP by their first bytes', () => {
    expect(imageTypeOf(bytes(0xff, 0xd8, 0xff, 0xe0))).toBe('image/jpeg');
    expect(imageTypeOf(bytes(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a))).toBe('image/png');
    expect(imageTypeOf(Buffer.from('RIFF\x10\x00\x00\x00WEBPVP8 ', 'latin1'))).toBe('image/webp');
  });

  it('refuses anything else, and files too short to tell', () => {
    expect(imageTypeOf(Buffer.from('<html><script>alert(1)</script>'))).toBeNull();
    expect(imageTypeOf(Buffer.from('RIFF\x10\x00\x00\x00WAVE', 'latin1'))).toBeNull();
    expect(imageTypeOf(Buffer.from('GIF89a'))).toBeNull();
    expect(imageTypeOf(bytes(0xff, 0xd8))).toBeNull();
    expect(imageTypeOf(bytes())).toBeNull();
  });
});
