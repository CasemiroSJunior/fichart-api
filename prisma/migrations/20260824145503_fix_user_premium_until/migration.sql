/*
  Warnings:

  - You are about to drop the column `premium_active` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `premium_date` on the `users` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "users" DROP COLUMN "premium_active",
DROP COLUMN "premium_date",
ADD COLUMN     "premium_until" TIMESTAMP(3);
