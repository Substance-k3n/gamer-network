import { HttpStatus } from '@nestjs/common';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';
import { AppError } from './app-error.js';

// docs/API.md "Lists": ?limit=20&cursor=<opaque> → { items, nextCursor }.
// The cursor is the last item's UUIDv7 id: ids sort by creation time.

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;

export class PageQuery {
  /** 1–50, default 20. */
  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;

  /** `nextCursor` from the previous page. */
  @IsOptional()
  @IsString()
  cursor?: string;
}

export const encodeCursor = (id: string) => Buffer.from(id).toString('base64url');

/** The id to continue after, or undefined for the first page. */
export function decodeCursor(cursor: string | undefined): string | undefined {
  if (!cursor) return undefined;
  const id = Buffer.from(cursor, 'base64url').toString();
  if (!UUID.test(id)) {
    throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', 'Bad cursor.', {
      cursor: 'Use nextCursor from the previous page',
    });
  }
  return id;
}

/** Fetch limit + 1 rows; this trims the extra one and says whether there is more. */
export function page<T extends { id: string }>(rows: T[], limit: number) {
  const items = rows.slice(0, limit);
  const nextCursor = rows.length > limit ? encodeCursor(items.at(-1)!.id) : null;
  return { items, nextCursor };
}
