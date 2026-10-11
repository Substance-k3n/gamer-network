ALTER TABLE "devices" ADD COLUMN "session_id" uuid;--> statement-breakpoint
ALTER TABLE "notifications" ADD COLUMN "pushed_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "devices" ADD CONSTRAINT "devices_session_id_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "public"."sessions"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "notifications_unpushed" ON "notifications" USING btree ("id") WHERE "notifications"."pushed_at" is null;--> statement-breakpoint
-- Notifications from before push existed are not sent now.
UPDATE "notifications" SET "pushed_at" = "created_at";
