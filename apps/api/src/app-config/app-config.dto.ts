export class AppConfigResponse {
  /** Apps below this version must update (they get 426 everywhere else). */
  minSupportedVersion: string;

  /** Newest released version, for a gentle "Update available". */
  latestVersion: string;

  /** The one city the beta runs in. */
  launchCity: string;

  /** Show the Groups tab as "coming soon" with a waitlist. False once groups ship (the opposite of groupsEnabled). */
  groupsComingSoon: boolean;

  /** Show the Home feed (posts, comments, GG). On by default (FEED_ENABLED=false turns it off). */
  feedEnabled: boolean;

  /** Show Groups for real. On by default (GROUPS_ENABLED=false turns it off). */
  groupsEnabled: boolean;
}
