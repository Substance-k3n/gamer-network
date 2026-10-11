// The launch city runs on Africa/Addis_Ababa: UTC+3 all year, no
// daylight saving (docs/DATA_MODEL.md "Conventions").
const OFFSET_MS = 3 * 60 * 60 * 1000;
const HOUR_MS = 60 * 60 * 1000;

/** The instant at `hour`:00 Addis time on the Addis calendar day of `at`, plus `addDays`. */
export function addisAt(at: Date, hour: number, addDays = 0): Date {
  const local = new Date(at.getTime() + OFFSET_MS);
  local.setUTCHours(hour, 0, 0, 0);
  local.setUTCDate(local.getUTCDate() + addDays);
  return new Date(local.getTime() - OFFSET_MS);
}

/** "Tonight" ends at 04:00 Addis time: the next morning, or this morning if it is still before 04:00. */
export function endOfTonight(now: Date): Date {
  const today4am = addisAt(now, 4);
  return now < today4am ? today4am : addisAt(now, 4, 1);
}

export const hoursFrom = (now: Date, hours: number) => new Date(now.getTime() + hours * HOUR_MS);
