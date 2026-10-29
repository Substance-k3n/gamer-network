ALTER TYPE "public"."admin_action_kind" ADD VALUE 'create_game';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'update_game';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'delete_game';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'create_rank';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'update_rank';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'delete_rank';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'create_user';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'update_user';--> statement-breakpoint
ALTER TYPE "public"."admin_action_kind" ADD VALUE 'delete_user';--> statement-breakpoint
ALTER TABLE "games" ADD COLUMN "deleted_at" timestamp with time zone;