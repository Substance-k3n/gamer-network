ALTER TYPE "public"."admin_action_kind" ADD VALUE 'set_launch';--> statement-breakpoint
ALTER TABLE "admin_actions" ADD COLUMN "game_id" text;--> statement-breakpoint
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_game_id_games_id_fk" FOREIGN KEY ("game_id") REFERENCES "public"."games"("id") ON DELETE no action ON UPDATE no action;