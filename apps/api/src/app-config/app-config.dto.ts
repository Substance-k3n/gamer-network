export class AppConfigResponse {
  /** Apps below this version must update (they get 426 everywhere else). */
  minSupportedVersion: string;

  /** Newest released version, for a gentle "Update available". */
  latestVersion: string;

  /** The one city the beta runs in. */
  launchCity: string;

  /** Show the Groups tab as "coming soon" with a waitlist. */
  groupsComingSoon: boolean;

  /** Show the Home feed (posts, comments, GG). Off: today's Home. */
  feedEnabled: boolean;

  /** Show Groups for real. Off until groups ship; then groupsComingSoon goes away. */
  groupsEnabled: boolean;
}
