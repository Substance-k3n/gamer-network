/** The constraint name when `e` is a Postgres unique violation, else undefined. */
export function uniqueViolation(e: unknown): string | undefined {
  const err = e as {
    code?: string;
    constraint_name?: string;
    cause?: { code?: string; constraint_name?: string };
  };
  const c = err.cause ?? err;
  return c.code === '23505' ? c.constraint_name : undefined;
}
