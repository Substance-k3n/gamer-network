import { IsEmail, IsInt, Max } from 'class-validator';
import { AppError } from './app-error.js';
import { validationPipe } from './validation.js';

class Body {
  @IsEmail()
  email: string;

  @IsInt()
  @Max(5)
  size: number;
}

const run = (value: unknown) => validationPipe.transform(value, { type: 'body', metatype: Body });

describe('validationPipe', () => {
  it('answers 422 with one problem per field', async () => {
    const err = await run({ email: 'nope', size: 9 }).catch((e: unknown) => e);
    expect(err).toBeInstanceOf(AppError);
    expect((err as AppError).getStatus()).toBe(422);
    expect((err as AppError).fields).toEqual({
      email: 'email must be an email',
      size: 'size must not be greater than 5',
    });
  });

  it('refuses fields the endpoint does not take', async () => {
    const err = (await run({ email: 'a@b.co', size: 2, role: 'admin' }).catch(
      (e: unknown) => e,
    )) as AppError;
    expect(err.fields).toEqual({ role: 'property role should not exist' });
  });

  it('passes valid bodies through as the DTO class', async () => {
    await expect(run({ email: 'a@b.co', size: 2 })).resolves.toBeInstanceOf(Body);
  });
});
