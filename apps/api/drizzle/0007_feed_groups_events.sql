CREATE TYPE "public"."group_kind" AS ENUM('game', 'city', 'campus', 'squad');--> statement-breakpoint
CREATE TYPE "public"."group_role" AS ENUM('admin', 'member');--> statement-breakpoint
CREATE TYPE "public"."group_tone" AS ENUM('accent', 'lav', 'soft', 'grey');--> statement-breakpoint
CREATE TYPE "public"."membership_status" AS ENUM('member', 'pending');--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'remove_group';--> statement-breakpoint
ALTER TYPE "public"."notification_type" ADD VALUE 'group_join_request';--> statement-breakpoint
ALTER TYPE "public"."notification_type" ADD VALUE 'group_join_approved';--> statement-breakpoint
ALTER TYPE "public"."notification_type" ADD VALUE 'group_event';--> statement-breakpoint
CREATE TABLE "group_event_going" (
	"event_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "group_event_going_event_id_user_id_pk" PRIMARY KEY("event_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "group_events" (
	"id" uuid PRIMARY KEY NOT NULL,
	"group_id" uuid NOT NULL,
	"created_by" uuid NOT NULL,
	"title" text NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"game_id" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "group_events_title_length" CHECK (char_length("group_events"."title") between 1 and 80)
);
--> statement-breakpoint
CREATE TABLE "group_members" (
	"group_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"role" "group_role" DEFAULT 'member' NOT NULL,
	"status" "membership_status" NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"joined_at" timestamp with time zone,
	CONSTRAINT "group_members_group_id_user_id_pk" PRIMARY KEY("group_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "groups" (
	"id" uuid PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"short" text NOT NULL,
	"kind" "group_kind" NOT NULL,
	"game_id" text,
	"place" text NOT NULL,
	"about" text DEFAULT '' NOT NULL,
	"rules" text[] DEFAULT '{}'::text[] NOT NULL,
	"tone" "group_tone" DEFAULT 'accent' NOT NULL,
	"approval" boolean DEFAULT false NOT NULL,
	"created_by" uuid NOT NULL,
	"member_count" integer DEFAULT 0 NOT NULL,
	"status" "content_status" DEFAULT 'live' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "groups_name_length" CHECK (char_length("groups"."name") between 3 and 40),
	CONSTRAINT "groups_short_format" CHECK ("groups"."short" ~ '^[A-Z0-9]{2,5}$'),
	CONSTRAINT "groups_place_length" CHECK (char_length("groups"."place") between 1 and 60),
	CONSTRAINT "groups_about_length" CHECK (char_length("groups"."about") <= 500),
	CONSTRAINT "groups_rules_count" CHECK (coalesce(array_length("groups"."rules", 1), 0) <= 10),
	CONSTRAINT "groups_game_kind" CHECK ("groups"."kind" <> 'game' or "groups"."game_id" is not null)
);
--> statement-breakpoint
ALTER TABLE "posts" ADD COLUMN "group_id" uuid;--> statement-breakpoint
ALTER TABLE "notifications" ADD COLUMN "group_id" uuid;--> statement-breakpoint
ALTER TABLE "notifications" ADD COLUMN "group_event_id" uuid;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD COLUMN "group_id" uuid;--> statement-breakpoint
ALTER TABLE "reports" ADD COLUMN "group_id" uuid;--> statement-breakpoint
ALTER TABLE "group_event_going" ADD CONSTRAINT "group_event_going_event_id_group_events_id_fk" FOREIGN KEY ("event_id") REFERENCES "public"."group_events"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "group_event_going" ADD CONSTRAINT "group_event_going_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "group_events" ADD CONSTRAINT "group_events_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "group_events" ADD CONSTRAINT "group_events_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "group_events" ADD CONSTRAINT "group_events_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "groups" ADD CONSTRAINT "groups_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "groups" ADD CONSTRAINT "groups_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "group_events_upcoming" ON "group_events" USING btree ("group_id","starts_at");--> statement-breakpoint
CREATE INDEX "group_members_by_user" ON "group_members" USING btree ("user_id","status");--> statement-breakpoint
CREATE INDEX "group_members_of_group" ON "group_members" USING btree ("group_id","status","role");--> statement-breakpoint
CREATE UNIQUE INDEX "groups_name_unique" ON "groups" USING btree (lower("name")) WHERE "groups"."status" = 'live';--> statement-breakpoint
CREATE INDEX "groups_discover" ON "groups" USING btree ("status","member_count" DESC NULLS LAST,"id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "groups_by_creator" ON "groups" USING btree ("created_by","created_at");--> statement-breakpoint
ALTER TABLE "posts" ADD CONSTRAINT "posts_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_group_event_id_group_events_id_fk" FOREIGN KEY ("group_event_id") REFERENCES "public"."group_events"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reports" ADD CONSTRAINT "reports_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "posts_of_group" ON "posts" USING btree ("group_id","id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "notifications_of_group" ON "notifications" USING btree ("group_id","created_at");