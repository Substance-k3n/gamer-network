CREATE TYPE "public"."admin_action_kind" AS ENUM('ban', 'unban', 'remove_listing', 'dismiss_report', 'warn');--> statement-breakpoint
CREATE TYPE "public"."age_range" AS ENUM('16_17', '18_24', '25_34', '35_plus');--> statement-breakpoint
CREATE TYPE "public"."check_in_answer" AS ENUM('played', 'not_yet', 'no');--> statement-breakpoint
CREATE TYPE "public"."email_code_purpose" AS ENUM('verify_email', 'reset_password');--> statement-breakpoint
CREATE TYPE "public"."gaming_id_kind" AS ENUM('riot', 'steam', 'discord', 'playstation', 'xbox', 'epic', 'ea', 'activision', 'in_game');--> statement-breakpoint
CREATE TYPE "public"."id_visibility" AS ENUM('public', 'connections');--> statement-breakpoint
CREATE TYPE "public"."invite_status" AS ENUM('pending', 'accepted', 'declined', 'expired');--> statement-breakpoint
CREATE TYPE "public"."invite_when" AS ENUM('now', 'in_30_min', 'tonight');--> statement-breakpoint
CREATE TYPE "public"."listing_status" AS ENUM('open', 'full', 'closed', 'expired', 'removed');--> statement-breakpoint
CREATE TYPE "public"."notification_type" AS ENUM('connection_request', 'connection_accepted', 'play_invite', 'play_invite_accepted', 'check_in_due', 'listing_expiring', 'report_resolved');--> statement-breakpoint
CREATE TYPE "public"."platform" AS ENUM('pc', 'playstation', 'xbox', 'mobile', 'switch');--> statement-breakpoint
CREATE TYPE "public"."play_style" AS ENUM('competitive', 'casual');--> statement-breakpoint
CREATE TYPE "public"."play_tag" AS ENUM('competitive', 'casual', 'fps', 'rpg', 'strategy', 'co_op', 'ranked', 'achievement_hunter', 'story');--> statement-breakpoint
CREATE TYPE "public"."play_when" AS ENUM('now', 'tonight', 'weekend');--> statement-breakpoint
CREATE TYPE "public"."player_status" AS ENUM('looking', 'playing', 'available_tonight', 'not_available');--> statement-breakpoint
CREATE TYPE "public"."report_reason" AS ENUM('harassment', 'hate', 'sexual_content', 'underage', 'spam', 'impersonation', 'cheating_or_scam', 'other');--> statement-breakpoint
CREATE TYPE "public"."report_status" AS ENUM('open', 'actioned', 'dismissed');--> statement-breakpoint
CREATE TYPE "public"."request_status" AS ENUM('pending', 'accepted', 'declined', 'cancelled', 'expired');--> statement-breakpoint
CREATE TYPE "public"."user_role" AS ENUM('player', 'admin');--> statement-breakpoint
CREATE TYPE "public"."voice" AS ENUM('required', 'optional');--> statement-breakpoint
CREATE TABLE "game_modes" (
	"id" uuid PRIMARY KEY NOT NULL,
	"game_id" text NOT NULL,
	"name" text NOT NULL,
	"is_ranked" boolean DEFAULT false NOT NULL,
	CONSTRAINT "game_modes_game_id_name_unique" UNIQUE("game_id","name"),
	CONSTRAINT "game_modes_game_id_id_unique" UNIQUE("game_id","id")
);
--> statement-breakpoint
CREATE TABLE "game_ranks" (
	"id" uuid PRIMARY KEY NOT NULL,
	"game_id" text NOT NULL,
	"name" text NOT NULL,
	"tier" smallint NOT NULL,
	CONSTRAINT "game_ranks_game_id_tier_unique" UNIQUE("game_id","tier"),
	CONSTRAINT "game_ranks_game_id_id_unique" UNIQUE("game_id","id")
);
--> statement-breakpoint
CREATE TABLE "game_roles" (
	"id" uuid PRIMARY KEY NOT NULL,
	"game_id" text NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT "game_roles_game_id_id_unique" UNIQUE("game_id","id")
);
--> statement-breakpoint
CREATE TABLE "games" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"short_code" text NOT NULL,
	"platforms" "platform"[] NOT NULL,
	"has_ranks" boolean DEFAULT true NOT NULL,
	"max_party" smallint DEFAULT 5 NOT NULL,
	"is_launch" boolean DEFAULT false NOT NULL,
	"sort" smallint DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "auth_identities" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"provider" text NOT NULL,
	"subject" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "auth_identities_provider_subject_unique" UNIQUE("provider","subject")
);
--> statement-breakpoint
CREATE TABLE "devices" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"fcm_token" text NOT NULL,
	"platform" text NOT NULL,
	"app_version" text,
	"last_seen_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "devices_fcm_token_unique" UNIQUE("fcm_token"),
	CONSTRAINT "devices_platform" CHECK ("devices"."platform" in ('android', 'ios', 'web'))
);
--> statement-breakpoint
CREATE TABLE "email_codes" (
	"id" uuid PRIMARY KEY NOT NULL,
	"email" "citext" NOT NULL,
	"purpose" "email_code_purpose" NOT NULL,
	"code_hash" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"attempts" smallint DEFAULT 0 NOT NULL,
	"consumed_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sessions" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"token_hash" "bytea" NOT NULL,
	"user_agent" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"last_seen_at" timestamp with time zone DEFAULT now() NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"revoked_at" timestamp with time zone,
	CONSTRAINT "sessions_token_hash_unique" UNIQUE("token_hash")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" uuid PRIMARY KEY NOT NULL,
	"email" "citext" NOT NULL,
	"email_verified_at" timestamp with time zone,
	"password_hash" text,
	"username" "citext" NOT NULL,
	"display_name" text NOT NULL,
	"bio" text,
	"avatar_key" text,
	"age_range" "age_range" NOT NULL,
	"country" char(2) DEFAULT 'ET' NOT NULL,
	"city" text DEFAULT 'Addis Ababa' NOT NULL,
	"status" "player_status" DEFAULT 'not_available' NOT NULL,
	"status_game_id" text,
	"status_until" timestamp with time zone,
	"available_days" smallint DEFAULT 0 NOT NULL,
	"role" "user_role" DEFAULT 'player' NOT NULL,
	"onboarded_at" timestamp with time zone,
	"banned_at" timestamp with time zone,
	"ban_reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "users_email_unique" UNIQUE("email"),
	CONSTRAINT "users_username_unique" UNIQUE("username"),
	CONSTRAINT "users_username_format" CHECK ("users"."username"::text ~ '^[a-z0-9._]{3,20}$'),
	CONSTRAINT "users_display_name_length" CHECK (char_length("users"."display_name") between 1 and 30),
	CONSTRAINT "users_bio_length" CHECK (char_length("users"."bio") <= 160),
	CONSTRAINT "users_available_days_range" CHECK ("users"."available_days" between 0 and 127)
);
--> statement-breakpoint
CREATE TABLE "listings" (
	"id" uuid PRIMARY KEY NOT NULL,
	"owner_id" uuid NOT NULL,
	"game_id" text NOT NULL,
	"mode_id" uuid,
	"rank_id" uuid,
	"platform" "platform" NOT NULL,
	"party_size" smallint NOT NULL,
	"filled" smallint DEFAULT 0 NOT NULL,
	"voice" "voice" NOT NULL,
	"style" "play_style" NOT NULL,
	"play_when" "play_when" NOT NULL,
	"duration_hours" smallint NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"note" text,
	"city" text NOT NULL,
	"status" "listing_status" DEFAULT 'open' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"closed_at" timestamp with time zone,
	CONSTRAINT "listings_party_size" CHECK ("listings"."party_size" between 2 and 5),
	CONSTRAINT "listings_filled_range" CHECK ("listings"."filled" between 0 and "listings"."party_size" - 1),
	CONSTRAINT "listings_duration" CHECK ("listings"."duration_hours" in (2, 6, 24)),
	CONSTRAINT "listings_note_length" CHECK (char_length("listings"."note") <= 140),
	CONSTRAINT "listings_expires_after_created" CHECK ("listings"."expires_at" > "listings"."created_at")
);
--> statement-breakpoint
CREATE TABLE "notifications" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"type" "notification_type" NOT NULL,
	"actor_id" uuid,
	"listing_id" uuid,
	"connection_request_id" uuid,
	"play_invite_id" uuid,
	"check_in_id" uuid,
	"read_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "gaming_ids" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"kind" "gaming_id_kind" NOT NULL,
	"game_id" text,
	"value" text NOT NULL,
	"visibility" "id_visibility" DEFAULT 'connections' NOT NULL,
	CONSTRAINT "gaming_ids_user_kind_game_unique" UNIQUE NULLS NOT DISTINCT("user_id","kind","game_id"),
	CONSTRAINT "gaming_ids_in_game_needs_game" CHECK (("gaming_ids"."kind" = 'in_game') = ("gaming_ids"."game_id" is not null)),
	CONSTRAINT "gaming_ids_value_length" CHECK (char_length("gaming_ids"."value") between 1 and 64)
);
--> statement-breakpoint
CREATE TABLE "user_games" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"game_id" text,
	"custom_game_name" text,
	"rank_id" uuid,
	"rank_text" text,
	"role_id" uuid,
	"position" smallint DEFAULT 0 NOT NULL,
	CONSTRAINT "user_games_game_or_custom" CHECK (("user_games"."game_id" is null) <> ("user_games"."custom_game_name" is null)),
	CONSTRAINT "user_games_custom_name_length" CHECK (char_length("user_games"."custom_game_name") <= 40),
	CONSTRAINT "user_games_rank_text_length" CHECK (char_length("user_games"."rank_text") <= 30)
);
--> statement-breakpoint
CREATE TABLE "user_platforms" (
	"user_id" uuid NOT NULL,
	"platform" "platform" NOT NULL,
	CONSTRAINT "user_platforms_user_id_platform_pk" PRIMARY KEY("user_id","platform")
);
--> statement-breakpoint
CREATE TABLE "user_tags" (
	"user_id" uuid NOT NULL,
	"tag" "play_tag" NOT NULL,
	CONSTRAINT "user_tags_user_id_tag_pk" PRIMARY KEY("user_id","tag")
);
--> statement-breakpoint
CREATE TABLE "check_ins" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"other_user_id" uuid NOT NULL,
	"listing_id" uuid,
	"play_invite_id" uuid,
	"due_at" timestamp with time zone NOT NULL,
	"answer" "check_in_answer",
	"answered_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "connection_requests" (
	"id" uuid PRIMARY KEY NOT NULL,
	"from_user_id" uuid NOT NULL,
	"to_user_id" uuid NOT NULL,
	"listing_id" uuid,
	"message" text,
	"status" "request_status" DEFAULT 'pending' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"responded_at" timestamp with time zone,
	CONSTRAINT "connection_requests_not_self" CHECK ("connection_requests"."from_user_id" <> "connection_requests"."to_user_id"),
	CONSTRAINT "connection_requests_message_length" CHECK (char_length("connection_requests"."message") <= 140)
);
--> statement-breakpoint
CREATE TABLE "connections" (
	"user_a_id" uuid NOT NULL,
	"user_b_id" uuid NOT NULL,
	"source_request_id" uuid,
	"source_listing_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "connections_user_a_id_user_b_id_pk" PRIMARY KEY("user_a_id","user_b_id"),
	CONSTRAINT "connections_ordered_pair" CHECK ("connections"."user_a_id" < "connections"."user_b_id")
);
--> statement-breakpoint
CREATE TABLE "play_invites" (
	"id" uuid PRIMARY KEY NOT NULL,
	"from_user_id" uuid NOT NULL,
	"to_user_id" uuid NOT NULL,
	"game_id" text NOT NULL,
	"play_when" "invite_when" NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"status" "invite_status" DEFAULT 'pending' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"responded_at" timestamp with time zone,
	CONSTRAINT "play_invites_not_self" CHECK ("play_invites"."from_user_id" <> "play_invites"."to_user_id")
);
--> statement-breakpoint
CREATE TABLE "admin_actions" (
	"id" uuid PRIMARY KEY NOT NULL,
	"admin_id" uuid NOT NULL,
	"kind" "admin_action_kind" NOT NULL,
	"target_user_id" uuid,
	"listing_id" uuid,
	"report_id" uuid,
	"note" text DEFAULT '' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "blocks" (
	"blocker_id" uuid NOT NULL,
	"blocked_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "blocks_blocker_id_blocked_id_pk" PRIMARY KEY("blocker_id","blocked_id"),
	CONSTRAINT "blocks_not_self" CHECK ("blocks"."blocker_id" <> "blocks"."blocked_id")
);
--> statement-breakpoint
CREATE TABLE "reports" (
	"id" uuid PRIMARY KEY NOT NULL,
	"reporter_id" uuid NOT NULL,
	"target_user_id" uuid NOT NULL,
	"listing_id" uuid,
	"reason" "report_reason" NOT NULL,
	"details" text,
	"status" "report_status" DEFAULT 'open' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"resolved_by" uuid,
	"resolved_at" timestamp with time zone,
	"resolution_note" text,
	CONSTRAINT "reports_details_length" CHECK (char_length("reports"."details") <= 500)
);
--> statement-breakpoint
CREATE TABLE "waitlist" (
	"user_id" uuid NOT NULL,
	"topic" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "waitlist_user_id_topic_pk" PRIMARY KEY("user_id","topic")
);
--> statement-breakpoint
ALTER TABLE "game_modes" ADD CONSTRAINT "game_modes_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "game_ranks" ADD CONSTRAINT "game_ranks_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "game_roles" ADD CONSTRAINT "game_roles_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "auth_identities" ADD CONSTRAINT "auth_identities_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "devices" ADD CONSTRAINT "devices_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_status_game_id_games_id_fk" FOREIGN KEY ("status_game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "listings" ADD CONSTRAINT "listings_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "listings" ADD CONSTRAINT "listings_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "listings" ADD CONSTRAINT "listings_mode_of_game_fk" FOREIGN KEY ("game_id","mode_id") REFERENCES "public"."game_modes"("game_id","id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "listings" ADD CONSTRAINT "listings_rank_of_game_fk" FOREIGN KEY ("game_id","rank_id") REFERENCES "public"."game_ranks"("game_id","id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_actor_id_users_id_fk" FOREIGN KEY ("actor_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_listing_id_listings_id_fk" FOREIGN KEY ("listing_id") REFERENCES "public"."listings"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_connection_request_id_connection_requests_id_fk" FOREIGN KEY ("connection_request_id") REFERENCES "public"."connection_requests"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_play_invite_id_play_invites_id_fk" FOREIGN KEY ("play_invite_id") REFERENCES "public"."play_invites"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_check_in_id_check_ins_id_fk" FOREIGN KEY ("check_in_id") REFERENCES "public"."check_ins"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "gaming_ids" ADD CONSTRAINT "gaming_ids_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "gaming_ids" ADD CONSTRAINT "gaming_ids_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_games" ADD CONSTRAINT "user_games_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_games" ADD CONSTRAINT "user_games_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_games" ADD CONSTRAINT "user_games_rank_of_game_fk" FOREIGN KEY ("game_id","rank_id") REFERENCES "public"."game_ranks"("game_id","id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_games" ADD CONSTRAINT "user_games_role_of_game_fk" FOREIGN KEY ("game_id","role_id") REFERENCES "public"."game_roles"("game_id","id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_platforms" ADD CONSTRAINT "user_platforms_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_tags" ADD CONSTRAINT "user_tags_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "check_ins" ADD CONSTRAINT "check_ins_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "check_ins" ADD CONSTRAINT "check_ins_other_user_id_users_id_fk" FOREIGN KEY ("other_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "check_ins" ADD CONSTRAINT "check_ins_listing_id_listings_id_fk" FOREIGN KEY ("listing_id") REFERENCES "public"."listings"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "check_ins" ADD CONSTRAINT "check_ins_play_invite_id_play_invites_id_fk" FOREIGN KEY ("play_invite_id") REFERENCES "public"."play_invites"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connection_requests" ADD CONSTRAINT "connection_requests_from_user_id_users_id_fk" FOREIGN KEY ("from_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connection_requests" ADD CONSTRAINT "connection_requests_to_user_id_users_id_fk" FOREIGN KEY ("to_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connection_requests" ADD CONSTRAINT "connection_requests_listing_id_listings_id_fk" FOREIGN KEY ("listing_id") REFERENCES "public"."listings"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connections" ADD CONSTRAINT "connections_user_a_id_users_id_fk" FOREIGN KEY ("user_a_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connections" ADD CONSTRAINT "connections_user_b_id_users_id_fk" FOREIGN KEY ("user_b_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connections" ADD CONSTRAINT "connections_source_request_id_connection_requests_id_fk" FOREIGN KEY ("source_request_id") REFERENCES "public"."connection_requests"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "connections" ADD CONSTRAINT "connections_source_listing_id_listings_id_fk" FOREIGN KEY ("source_listing_id") REFERENCES "public"."listings"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "play_invites" ADD CONSTRAINT "play_invites_from_user_id_users_id_fk" FOREIGN KEY ("from_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "play_invites" ADD CONSTRAINT "play_invites_to_user_id_users_id_fk" FOREIGN KEY ("to_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "play_invites" ADD CONSTRAINT "play_invites_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_admin_id_users_id_fk" FOREIGN KEY ("admin_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_target_user_id_users_id_fk" FOREIGN KEY ("target_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_listing_id_listings_id_fk" FOREIGN KEY ("listing_id") REFERENCES "public"."listings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_report_id_reports_id_fk" FOREIGN KEY ("report_id") REFERENCES "public"."reports"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "blocks" ADD CONSTRAINT "blocks_blocker_id_users_id_fk" FOREIGN KEY ("blocker_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "blocks" ADD CONSTRAINT "blocks_blocked_id_users_id_fk" FOREIGN KEY ("blocked_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reports" ADD CONSTRAINT "reports_reporter_id_users_id_fk" FOREIGN KEY ("reporter_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reports" ADD CONSTRAINT "reports_target_user_id_users_id_fk" FOREIGN KEY ("target_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reports" ADD CONSTRAINT "reports_listing_id_listings_id_fk" FOREIGN KEY ("listing_id") REFERENCES "public"."listings"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reports" ADD CONSTRAINT "reports_resolved_by_users_id_fk" FOREIGN KEY ("resolved_by") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "waitlist" ADD CONSTRAINT "waitlist_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "auth_identities_user_id_index" ON "auth_identities" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "devices_user_id_index" ON "devices" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "email_codes_email_purpose_created_at_index" ON "email_codes" USING btree ("email","purpose","created_at");--> statement-breakpoint
CREATE INDEX "sessions_user_id_index" ON "sessions" USING btree ("user_id");--> statement-breakpoint
CREATE UNIQUE INDEX "listings_one_live_per_owner" ON "listings" USING btree ("owner_id") WHERE "listings"."status" in ('open', 'full');--> statement-breakpoint
CREATE INDEX "listings_open_feed" ON "listings" USING btree ("city","game_id","expires_at") WHERE "listings"."status" = 'open';--> statement-breakpoint
CREATE INDEX "notifications_user_id_id_index" ON "notifications" USING btree ("user_id","id" DESC NULLS LAST);--> statement-breakpoint
CREATE UNIQUE INDEX "user_games_user_game_unique" ON "user_games" USING btree ("user_id","game_id") WHERE "user_games"."game_id" is not null;--> statement-breakpoint
CREATE UNIQUE INDEX "user_games_user_custom_unique" ON "user_games" USING btree ("user_id",lower("custom_game_name")) WHERE "user_games"."custom_game_name" is not null;--> statement-breakpoint
CREATE UNIQUE INDEX "check_ins_per_listing" ON "check_ins" USING btree ("user_id","other_user_id","listing_id") WHERE "check_ins"."listing_id" is not null;--> statement-breakpoint
CREATE UNIQUE INDEX "check_ins_per_invite" ON "check_ins" USING btree ("user_id","play_invite_id") WHERE "check_ins"."play_invite_id" is not null;--> statement-breakpoint
CREATE INDEX "check_ins_user_id_due_at_index" ON "check_ins" USING btree ("user_id","due_at");--> statement-breakpoint
CREATE UNIQUE INDEX "connection_requests_one_pending" ON "connection_requests" USING btree ("from_user_id","to_user_id") WHERE "connection_requests"."status" = 'pending';--> statement-breakpoint
CREATE INDEX "connection_requests_to_user_id_status_index" ON "connection_requests" USING btree ("to_user_id","status");--> statement-breakpoint
CREATE INDEX "connection_requests_listing_id_index" ON "connection_requests" USING btree ("listing_id");--> statement-breakpoint
CREATE INDEX "connections_user_b_id_index" ON "connections" USING btree ("user_b_id");--> statement-breakpoint
CREATE INDEX "play_invites_to_user_id_status_index" ON "play_invites" USING btree ("to_user_id","status");--> statement-breakpoint
CREATE INDEX "blocks_blocked_id_index" ON "blocks" USING btree ("blocked_id");--> statement-breakpoint
CREATE INDEX "reports_status_created_at_index" ON "reports" USING btree ("status","created_at");