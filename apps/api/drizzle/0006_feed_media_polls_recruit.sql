CREATE TYPE "public"."application_status" AS ENUM('pending', 'accepted', 'declined');--> statement-breakpoint
CREATE TYPE "public"."media_kind" AS ENUM('image', 'video');--> statement-breakpoint
ALTER TYPE "public"."notification_type" ADD VALUE 'recruit_application';--> statement-breakpoint
ALTER TYPE "public"."notification_type" ADD VALUE 'recruit_accepted';--> statement-breakpoint
CREATE TABLE "media_uploads" (
	"key" text PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"kind" "media_kind" NOT NULL,
	"content_type" text NOT NULL,
	"size" integer NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"used_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "poll_options" (
	"post_id" uuid NOT NULL,
	"position" smallint NOT NULL,
	"label" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "poll_options_post_id_position_pk" PRIMARY KEY("post_id","position"),
	CONSTRAINT "poll_options_position_range" CHECK ("poll_options"."position" between 0 and 3),
	CONSTRAINT "poll_options_label_length" CHECK (char_length("poll_options"."label") between 1 and 60)
);
--> statement-breakpoint
CREATE TABLE "poll_votes" (
	"post_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"position" smallint NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "poll_votes_post_id_user_id_pk" PRIMARY KEY("post_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "polls" (
	"post_id" uuid PRIMARY KEY NOT NULL,
	"ends_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "post_media" (
	"id" uuid PRIMARY KEY NOT NULL,
	"post_id" uuid NOT NULL,
	"position" smallint NOT NULL,
	"kind" "media_kind" NOT NULL,
	"key" text NOT NULL,
	"content_type" text NOT NULL,
	"size" integer NOT NULL,
	"width" integer,
	"height" integer,
	"duration_ms" integer,
	"poster_key" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "post_media_position" UNIQUE("post_id","position"),
	CONSTRAINT "post_media_position_range" CHECK ("post_media"."position" between 0 and 3)
);
--> statement-breakpoint
CREATE TABLE "recruit_applications" (
	"id" uuid PRIMARY KEY NOT NULL,
	"post_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"status" "application_status" DEFAULT 'pending' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"decided_at" timestamp with time zone,
	CONSTRAINT "recruit_applications_once" UNIQUE("post_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "recruitments" (
	"post_id" uuid PRIMARY KEY NOT NULL,
	"slots" smallint NOT NULL,
	"roles" text DEFAULT '' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "recruitments_slots_range" CHECK ("recruitments"."slots" between 1 and 10),
	CONSTRAINT "recruitments_roles_length" CHECK (char_length("recruitments"."roles") <= 80)
);
--> statement-breakpoint
ALTER TABLE "notifications" ADD COLUMN "recruit_application_id" uuid;--> statement-breakpoint
ALTER TABLE "media_uploads" ADD CONSTRAINT "media_uploads_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "poll_options" ADD CONSTRAINT "poll_options_post_id_polls_post_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."polls"("post_id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "poll_votes" ADD CONSTRAINT "poll_votes_post_id_polls_post_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."polls"("post_id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "poll_votes" ADD CONSTRAINT "poll_votes_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "polls" ADD CONSTRAINT "polls_post_id_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "post_media" ADD CONSTRAINT "post_media_post_id_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recruit_applications" ADD CONSTRAINT "recruit_applications_post_id_recruitments_post_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."recruitments"("post_id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recruit_applications" ADD CONSTRAINT "recruit_applications_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recruitments" ADD CONSTRAINT "recruitments_post_id_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "media_uploads_by_user" ON "media_uploads" USING btree ("user_id","created_at");--> statement-breakpoint
CREATE INDEX "media_uploads_unused" ON "media_uploads" USING btree ("created_at") WHERE "media_uploads"."used_at" is null;--> statement-breakpoint
CREATE INDEX "recruit_applications_of_post" ON "recruit_applications" USING btree ("post_id","id");--> statement-breakpoint
CREATE INDEX "recruit_applications_by_user" ON "recruit_applications" USING btree ("user_id","created_at");--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_recruit_application_id_recruit_applications_id_fk" FOREIGN KEY ("recruit_application_id") REFERENCES "public"."recruit_applications"("id") ON DELETE cascade ON UPDATE no action;