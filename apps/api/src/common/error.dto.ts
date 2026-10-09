import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ErrorBody {
  /** Stable machine code, e.g. `listing_already_open`. */
  code: string;

  /** Safe to show to the user. */
  message: string;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
    description: 'Field name → problem, on 422',
  })
  fields?: Record<string, string>;
}

export class ErrorResponse {
  @ApiProperty({ type: ErrorBody })
  error: ErrorBody;
}
