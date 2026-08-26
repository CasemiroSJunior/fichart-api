/*
  Warnings:

  - You are about to drop the column `description` on the `backgrounds` table. All the data in the column will be lost.
  - You are about to drop the column `character_class_id` on the `characters` table. All the data in the column will be lost.
  - You are about to drop the column `level` on the `characters` table. All the data in the column will be lost.
  - You are about to drop the column `amount_cents` on the `payments` table. All the data in the column will be lost.
  - You are about to drop the column `speed` on the `races` table. All the data in the column will be lost.
  - You are about to drop the column `password_hash` on the `users` table. All the data in the column will be lost.
  - You are about to drop the `_CharacterToLanguage` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_LanguageToRace` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[srd_index]` on the table `backgrounds` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[srd_index]` on the table `character_classes` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[srd_index]` on the table `languages` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[srd_index]` on the table `races` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[srd_index]` on the table `subraces` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `updated_at` to the `backgrounds` table without a default value. This is not possible if the table is not empty.
  - Added the required column `visibility` to the `backgrounds` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `character_classes` table without a default value. This is not possible if the table is not empty.
  - Added the required column `visibility` to the `character_classes` table without a default value. This is not possible if the table is not empty.
  - Added the required column `current_hit_points` to the `characters` table without a default value. This is not possible if the table is not empty.
  - Added the required column `rarity` to the `languages` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `languages` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amount_minor_units` to the `payments` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `currency` on the `payments` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `age_description` to the `races` table without a default value. This is not possible if the table is not empty.
  - Added the required column `alignment_description` to the `races` table without a default value. This is not possible if the table is not empty.
  - Added the required column `language_description` to the `races` table without a default value. This is not possible if the table is not empty.
  - Added the required column `size_description` to the `races` table without a default value. This is not possible if the table is not empty.
  - Added the required column `speed_ft` to the `races` table without a default value. This is not possible if the table is not empty.
  - Added the required column `visibility` to the `races` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `subraces` table without a default value. This is not possible if the table is not empty.

*/
-- Create Extension Citext
CREATE EXTENSION IF NOT EXISTS citext;

-- CreateEnum
CREATE TYPE "Ability" AS ENUM ('STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA');

-- CreateEnum
CREATE TYPE "ContentSource" AS ENUM ('SRD', 'HOMEBREW');

-- CreateEnum
CREATE TYPE "ContentVisibility" AS ENUM ('PRIVATE', 'CAMPAIGN', 'PUBLIC');

-- CreateEnum
CREATE TYPE "TranslatableEntity" AS ENUM ('ABILITY_SCORE', 'SKILL', 'DAMAGE_TYPE', 'MAGIC_SCHOOL', 'CONDITION', 'ALIGNMENT', 'LANGUAGE', 'PROFICIENCY', 'EQUIPMENT_CATEGORY', 'WEAPON_PROPERTY', 'ITEM', 'SPELL', 'CHARACTER_CLASS', 'SUBCLASS', 'CLASS_FEATURE', 'CLASS_RESOURCE_DEFINITION', 'RACE', 'SUBRACE', 'RACIAL_TRAIT', 'BACKGROUND', 'FEAT');

-- CreateEnum
CREATE TYPE "ItemKind" AS ENUM ('WEAPON', 'ARMOR', 'GEAR', 'TOOL', 'VEHICLE', 'MAGIC');

-- CreateEnum
CREATE TYPE "WeaponCategory" AS ENUM ('SIMPLE', 'MARTIAL');

-- CreateEnum
CREATE TYPE "WeaponRange" AS ENUM ('MELEE', 'RANGED');

-- CreateEnum
CREATE TYPE "ArmorCategory" AS ENUM ('LIGHT', 'MEDIUM', 'HEAVY', 'SHIELD');

-- CreateEnum
CREATE TYPE "ToolCategory" AS ENUM ('ARTISANS_TOOLS', 'GAMING_SET', 'MUSICAL_INSTRUMENT', 'OTHER');

-- CreateEnum
CREATE TYPE "VehicleCategory" AS ENUM ('MOUNT_OR_ANIMAL', 'TACK_HARNESS_DRAWN', 'WATERBORNE');

-- CreateEnum
CREATE TYPE "SpeedUnit" AS ENUM ('FEET_PER_ROUND', 'MILES_PER_HOUR');

-- CreateEnum
CREATE TYPE "MagicItemRarity" AS ENUM ('COMMON', 'UNCOMMON', 'RARE', 'VERY_RARE', 'LEGENDARY', 'ARTIFACT', 'VARIES');

-- CreateEnum
CREATE TYPE "SpellAttackType" AS ENUM ('MELEE', 'RANGED');

-- CreateEnum
CREATE TYPE "SpellDcSuccess" AS ENUM ('NONE', 'HALF', 'OTHER');

-- CreateEnum
CREATE TYPE "SpellScalingKind" AS ENUM ('DAMAGE_BY_SLOT', 'DAMAGE_BY_CHARACTER_LEVEL', 'HEAL_BY_SLOT');

-- CreateEnum
CREATE TYPE "AreaOfEffectType" AS ENUM ('SPHERE', 'CUBE', 'CYLINDER', 'LINE', 'CONE');

-- CreateEnum
CREATE TYPE "CasterKind" AS ENUM ('FULL', 'HALF', 'THIRD', 'PACT');

-- CreateEnum
CREATE TYPE "SpellPreparationMode" AS ENUM ('KNOWN', 'PREPARED_FROM_LIST', 'PREPARED_FROM_SPELLBOOK');

-- CreateEnum
CREATE TYPE "AbilityImprovementKind" AS ENUM ('ASI', 'FEAT');

-- CreateEnum
CREATE TYPE "ClassResourceValueKind" AS ENUM ('COUNT', 'DIE_FACE', 'DICE', 'FLAG', 'CHALLENGE_RATING', 'SLOT_COST_TABLE');

-- CreateEnum
CREATE TYPE "FeatureGrantKind" AS ENUM ('LEVEL_GRANT', 'OPTION', 'CONTAINER');

-- CreateEnum
CREATE TYPE "FeaturePrerequisiteKind" AS ENUM ('LEVEL', 'FEATURE', 'SPELL');

-- CreateEnum
CREATE TYPE "SubclassSpellPrerequisiteKind" AS ENUM ('LEVEL', 'FEATURE');

-- CreateEnum
CREATE TYPE "ProficiencyCategory" AS ENUM ('ARMOR', 'WEAPON', 'ARTISANS_TOOLS', 'GAMING_SET', 'MUSICAL_INSTRUMENT', 'VEHICLE', 'SAVING_THROW', 'SKILL', 'OTHER');

-- CreateEnum
CREATE TYPE "ProficiencyOrigin" AS ENUM ('RACE', 'SUBRACE', 'CLASS', 'SUBCLASS', 'BACKGROUND', 'FEAT', 'OTHER');

-- CreateEnum
CREATE TYPE "GrantOrigin" AS ENUM ('RACE', 'SUBRACE', 'CLASS', 'SUBCLASS', 'BACKGROUND', 'FEAT', 'ITEM', 'CHOICE', 'OTHER');

-- CreateEnum
CREATE TYPE "LanguageRarity" AS ENUM ('STANDARD', 'EXOTIC');

-- CreateEnum
CREATE TYPE "LanguageScript" AS ENUM ('COMMON', 'DWARVISH', 'ELVISH', 'INFERNAL', 'CELESTIAL', 'DRACONIC');

-- CreateEnum
CREATE TYPE "ChoiceKind" AS ENUM ('PROFICIENCY', 'EXPERTISE', 'LANGUAGE', 'ABILITY_BONUS', 'ABILITY_SCORE_PREREQUISITE', 'EQUIPMENT', 'SPELL', 'TRAIT', 'FEATURE', 'ENEMY_TYPE', 'TERRAIN_TYPE', 'PERSONALITY_TRAIT', 'IDEAL', 'BOND', 'FLAW');

-- CreateEnum
CREATE TYPE "ChoiceAnchor" AS ENUM ('RACE_LANGUAGE', 'RACE_ABILITY_BONUS', 'SUBRACE_LANGUAGE', 'SUBRACE_ABILITY_BONUS', 'TRAIT_PROFICIENCY', 'TRAIT_LANGUAGE', 'TRAIT_SPELL', 'TRAIT_SUBTRAIT', 'CLASS_PROFICIENCY', 'CLASS_EQUIPMENT', 'MULTICLASS_PROFICIENCY', 'MULTICLASS_PREREQUISITE', 'FEATURE_EXPERTISE', 'FEATURE_SUBFEATURE', 'FEATURE_ENEMY_TYPE', 'FEATURE_TERRAIN_TYPE', 'BACKGROUND_PROFICIENCY', 'BACKGROUND_LANGUAGE', 'BACKGROUND_EQUIPMENT', 'BACKGROUND_PERSONALITY_TRAIT', 'BACKGROUND_IDEAL', 'BACKGROUND_BOND', 'BACKGROUND_FLAW', 'FEAT_PROFICIENCY', 'FEAT_ABILITY_BONUS', 'FEAT_LANGUAGE', 'NESTED');

-- CreateEnum
CREATE TYPE "OptionSetType" AS ENUM ('OPTIONS_ARRAY', 'EQUIPMENT_CATEGORY', 'RESOURCE_LIST');

-- CreateEnum
CREATE TYPE "ChoiceOptionType" AS ENUM ('REFERENCE', 'COUNTED_REFERENCE', 'CHOICE', 'MULTIPLE', 'TEXT', 'ABILITY_BONUS', 'ABILITY_SCORE_PREREQUISITE', 'IDEAL');

-- CreateEnum
CREATE TYPE "ChoiceTargetType" AS ENUM ('ITEM', 'EQUIPMENT_CATEGORY', 'PROFICIENCY', 'SKILL', 'LANGUAGE', 'SPELL', 'RACIAL_TRAIT', 'CLASS_FEATURE', 'SUBCLASS', 'ABILITY_SCORE');

-- CreateEnum
CREATE TYPE "UsageInterval" AS ENUM ('PER_TURN', 'PER_REST', 'PER_DAY');

-- CreateEnum
CREATE TYPE "CampaignRole" AS ENUM ('GM', 'PLAYER');

-- CreateEnum
CREATE TYPE "CharacterDraftStep" AS ENUM ('RACE', 'CHARACTER_CLASS', 'ABILITY_SCORES', 'BACKGROUND', 'EQUIPMENT');

-- CreateEnum
CREATE TYPE "Currency" AS ENUM ('BRL', 'USD', 'EUR');

-- CreateEnum
CREATE TYPE "SheetVisibility" AS ENUM ('PRIVATE', 'CAMPAIGN', 'PUBLIC');

-- DropForeignKey
ALTER TABLE "_CharacterToLanguage" DROP CONSTRAINT "_CharacterToLanguage_A_fkey";

-- DropForeignKey
ALTER TABLE "_CharacterToLanguage" DROP CONSTRAINT "_CharacterToLanguage_B_fkey";

-- DropForeignKey
ALTER TABLE "_LanguageToRace" DROP CONSTRAINT "_LanguageToRace_A_fkey";

-- DropForeignKey
ALTER TABLE "_LanguageToRace" DROP CONSTRAINT "_LanguageToRace_B_fkey";

-- DropForeignKey
ALTER TABLE "characters" DROP CONSTRAINT "characters_character_class_id_fkey";

-- DropForeignKey
ALTER TABLE "characters" DROP CONSTRAINT "characters_subrace_id_fkey";

-- DropForeignKey
ALTER TABLE "payments" DROP CONSTRAINT "payments_user_id_fkey";

-- DropIndex
DROP INDEX "backgrounds_name_key";

-- DropIndex
DROP INDEX "character_classes_name_key";

-- DropIndex
DROP INDEX "characters_character_class_id_idx";

-- DropIndex
DROP INDEX "characters_user_id_idx";

-- DropIndex
DROP INDEX "languages_name_key";

-- DropIndex
DROP INDEX "races_name_key";

-- DropIndex
DROP INDEX "subraces_race_id_name_key";

-- AlterTable
ALTER TABLE "backgrounds" DROP COLUMN "description",
ADD COLUMN     "campaign_id" TEXT,
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deleted_at" TIMESTAMP(3),
ADD COLUMN     "owner_id" TEXT,
ADD COLUMN     "source" "ContentSource" NOT NULL DEFAULT 'SRD',
ADD COLUMN     "srd_index" TEXT,
ADD COLUMN     "starting_gold_cp" INTEGER,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "visibility" "ContentVisibility" NOT NULL;

-- AlterTable
ALTER TABLE "character_classes" ADD COLUMN     "campaign_id" TEXT,
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deleted_at" TIMESTAMP(3),
ADD COLUMN     "owner_id" TEXT,
ADD COLUMN     "source" "ContentSource" NOT NULL DEFAULT 'SRD',
ADD COLUMN     "srd_index" TEXT,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "visibility" "ContentVisibility" NOT NULL;

-- AlterTable
ALTER TABLE "characters" DROP COLUMN "character_class_id",
DROP COLUMN "level",
ADD COLUMN     "alignment_id" TEXT,
ADD COLUMN     "allies_and_organizations" TEXT,
ADD COLUMN     "appearance" TEXT,
ADD COLUMN     "armor_class_bonus" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "armor_class_override" INTEGER,
ADD COLUMN     "backstory" TEXT,
ADD COLUMN     "bonds" TEXT[],
ADD COLUMN     "campaign_id" TEXT,
ADD COLUMN     "copper_pieces" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "current_hit_points" INTEGER NOT NULL,
ADD COLUMN     "death_save_failures" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "death_save_successes" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "electrum_pieces" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "experience_points" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "flaws" TEXT[],
ADD COLUMN     "gold_pieces" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "ideals" TEXT[],
ADD COLUMN     "inspiration" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "notes" TEXT,
ADD COLUMN     "personality_traits" TEXT[],
ADD COLUMN     "platinum_pieces" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "sheet_visibility" "SheetVisibility" NOT NULL DEFAULT 'PRIVATE',
ADD COLUMN     "silver_pieces" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "temporary_hit_points" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "languages" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "description" TEXT[],
ADD COLUMN     "rarity" "LanguageRarity" NOT NULL,
ADD COLUMN     "script" "LanguageScript",
ADD COLUMN     "source" "ContentSource" NOT NULL DEFAULT 'SRD',
ADD COLUMN     "srd_index" TEXT,
ADD COLUMN     "typical_speakers" TEXT[],
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "payments" DROP COLUMN "amount_cents",
ADD COLUMN     "amount_minor_units" INTEGER NOT NULL,
ADD COLUMN     "granted_from" TIMESTAMP(3),
ADD COLUMN     "granted_until" TIMESTAMP(3),
ALTER COLUMN "user_id" DROP NOT NULL,
DROP COLUMN "currency",
ADD COLUMN     "currency" "Currency" NOT NULL;

-- AlterTable
ALTER TABLE "races" DROP COLUMN "speed",
ADD COLUMN     "age_description" TEXT NOT NULL,
ADD COLUMN     "alignment_description" TEXT NOT NULL,
ADD COLUMN     "campaign_id" TEXT,
ADD COLUMN     "deleted_at" TIMESTAMP(3),
ADD COLUMN     "language_description" TEXT NOT NULL,
ADD COLUMN     "owner_id" TEXT,
ADD COLUMN     "size_description" TEXT NOT NULL,
ADD COLUMN     "source" "ContentSource" NOT NULL DEFAULT 'SRD',
ADD COLUMN     "speed_ft" INTEGER NOT NULL,
ADD COLUMN     "srd_index" TEXT,
ADD COLUMN     "visibility" "ContentVisibility" NOT NULL;

-- AlterTable
ALTER TABLE "subraces" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deleted_at" TIMESTAMP(3),
ADD COLUMN     "description" TEXT[],
ADD COLUMN     "source" "ContentSource" NOT NULL DEFAULT 'SRD',
ADD COLUMN     "srd_index" TEXT,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "users" DROP COLUMN "password_hash",
ALTER COLUMN "email" SET DATA TYPE CITEXT;

-- DropTable
DROP TABLE "_CharacterToLanguage";

-- DropTable
DROP TABLE "_LanguageToRace";

-- CreateTable
CREATE TABLE "ability_scores" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "ability" "Ability" NOT NULL,
    "abbreviation" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ability_scores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "skills" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "ability" "Ability" NOT NULL,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "skills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "damage_types" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "damage_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "magic_schools" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "magic_schools_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conditions" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "is_graded" BOOLEAN NOT NULL DEFAULT false,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "conditions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alignments" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "abbreviation" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "alignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "proficiencies" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "category" "ProficiencyCategory" NOT NULL,
    "item_id" TEXT,
    "equipment_category_id" TEXT,
    "skill_id" TEXT,
    "saving_throw" "Ability",
    "target_srd_index" TEXT,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "proficiencies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "option_choices" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "choose_count" INTEGER NOT NULL,
    "kind" "ChoiceKind" NOT NULL,
    "description" TEXT,
    "option_set_type" "OptionSetType" NOT NULL,
    "equipment_category_id" TEXT,
    "resource_list_url" TEXT,
    "anchor" "ChoiceAnchor" NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "race_id" TEXT,
    "subrace_id" TEXT,
    "racial_trait_id" TEXT,
    "character_class_id" TEXT,
    "class_feature_id" TEXT,
    "background_id" TEXT,
    "feat_id" TEXT,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "option_choices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "choice_options" (
    "id" TEXT NOT NULL,
    "choice_id" TEXT NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "option_type" "ChoiceOptionType" NOT NULL,
    "nested_choice_id" TEXT,
    "parent_option_id" TEXT,
    "text_value" TEXT,
    "ability" "Ability",
    "numeric_value" INTEGER,

    CONSTRAINT "choice_options_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "choice_option_references" (
    "id" TEXT NOT NULL,
    "choice_option_id" TEXT NOT NULL,
    "target_type" "ChoiceTargetType" NOT NULL,
    "target_srd_index" TEXT NOT NULL,
    "count" INTEGER,
    "item_id" TEXT,
    "equipment_category_id" TEXT,
    "proficiency_id" TEXT,
    "skill_id" TEXT,
    "language_id" TEXT,
    "spell_id" TEXT,
    "racial_trait_id" TEXT,
    "class_feature_id" TEXT,
    "subclass_id" TEXT,
    "ability" "Ability",

    CONSTRAINT "choice_option_references_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "choice_option_alignments" (
    "id" TEXT NOT NULL,
    "choice_option_id" TEXT NOT NULL,
    "alignment_id" TEXT NOT NULL,

    CONSTRAINT "choice_option_alignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "equipment_categories" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "equipment_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "items" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "item_kind" "ItemKind" NOT NULL,
    "cost_cp" INTEGER,
    "weight_centi_lb" INTEGER,
    "quantity_per_cost" INTEGER,
    "tool_category" "ToolCategory",
    "description" TEXT[],
    "image_url" TEXT,
    "based_on_item_id" TEXT,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "owner_id" TEXT,
    "visibility" "ContentVisibility" NOT NULL,
    "campaign_id" TEXT,
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "weapon_details" (
    "id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "weapon_category" "WeaponCategory" NOT NULL,
    "weapon_range" "WeaponRange" NOT NULL,
    "damage_dice" TEXT,
    "damage_type_id" TEXT,
    "two_handed_damage_dice" TEXT,
    "two_handed_damage_type_id" TEXT,
    "range_normal" INTEGER NOT NULL,
    "range_long" INTEGER,
    "throw_range_normal" INTEGER,
    "throw_range_long" INTEGER,
    "special" TEXT[],

    CONSTRAINT "weapon_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "armor_details" (
    "id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "armor_category" "ArmorCategory" NOT NULL,
    "ac_base" INTEGER NOT NULL,
    "ac_dex_bonus" BOOLEAN NOT NULL,
    "ac_max_bonus" INTEGER,
    "str_minimum" INTEGER NOT NULL,
    "stealth_disadvantage" BOOLEAN NOT NULL,

    CONSTRAINT "armor_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicle_details" (
    "id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "vehicle_category" "VehicleCategory" NOT NULL,
    "speed_centi_value" INTEGER,
    "speed_unit" "SpeedUnit",
    "capacity_lb" INTEGER,

    CONSTRAINT "vehicle_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "magic_item_details" (
    "id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "rarity" "MagicItemRarity" NOT NULL,
    "requires_attunement" BOOLEAN,

    CONSTRAINT "magic_item_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "item_categories" (
    "id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "equipment_category_id" TEXT NOT NULL,

    CONSTRAINT "item_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "weapon_properties" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "weapon_properties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "item_weapon_properties" (
    "id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "weapon_property_id" TEXT NOT NULL,

    CONSTRAINT "item_weapon_properties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "item_pack_contents" (
    "id" TEXT NOT NULL,
    "pack_item_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "item_pack_contents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spells" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "level" INTEGER NOT NULL,
    "casting_time" TEXT NOT NULL,
    "range_text" TEXT NOT NULL,
    "duration_text" TEXT NOT NULL,
    "requires_verbal" BOOLEAN NOT NULL,
    "requires_somatic" BOOLEAN NOT NULL,
    "requires_material" BOOLEAN NOT NULL,
    "material_description" TEXT,
    "ritual" BOOLEAN NOT NULL,
    "concentration" BOOLEAN NOT NULL,
    "magic_school_id" TEXT NOT NULL,
    "attack_type" "SpellAttackType",
    "save_ability" "Ability",
    "save_success" "SpellDcSuccess",
    "save_description" TEXT,
    "damage_type_id" TEXT,
    "area_of_effect_type" "AreaOfEffectType",
    "area_of_effect_size_ft" INTEGER,
    "description" TEXT[],
    "higher_level_desc" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "owner_id" TEXT,
    "visibility" "ContentVisibility" NOT NULL,
    "campaign_id" TEXT,
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "spells_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spell_scalings" (
    "id" TEXT NOT NULL,
    "spell_id" TEXT NOT NULL,
    "kind" "SpellScalingKind" NOT NULL,
    "level" INTEGER NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "spell_scalings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spell_classes" (
    "id" TEXT NOT NULL,
    "spell_id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,

    CONSTRAINT "spell_classes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spell_subclasses" (
    "id" TEXT NOT NULL,
    "spell_id" TEXT NOT NULL,
    "subclass_id" TEXT NOT NULL,

    CONSTRAINT "spell_subclasses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_saving_throws" (
    "id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "ability" "Ability" NOT NULL,

    CONSTRAINT "class_saving_throws_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_proficiency_grants" (
    "id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "proficiency_id" TEXT NOT NULL,
    "on_multiclass" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "class_proficiency_grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_starting_equipment_items" (
    "id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "class_starting_equipment_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "multiclass_prerequisites" (
    "id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "ability" "Ability" NOT NULL,
    "minimum_score" INTEGER NOT NULL,

    CONSTRAINT "multiclass_prerequisites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_spellcastings" (
    "id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "min_level" INTEGER NOT NULL,
    "spellcasting_ability" "Ability" NOT NULL,
    "caster_kind" "CasterKind" NOT NULL,
    "preparation_mode" "SpellPreparationMode" NOT NULL,
    "ritual_casting" BOOLEAN NOT NULL DEFAULT false,
    "ritual_requires_prepared" BOOLEAN NOT NULL DEFAULT false,
    "infoBlocks" JSONB,

    CONSTRAINT "class_spellcastings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subclasses" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "subclass_flavor" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subclasses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subclass_spells" (
    "id" TEXT NOT NULL,
    "subclass_id" TEXT NOT NULL,
    "spell_id" TEXT NOT NULL,

    CONSTRAINT "subclass_spells_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subclass_spell_prerequisites" (
    "id" TEXT NOT NULL,
    "subclass_spell_id" TEXT NOT NULL,
    "kind" "SubclassSpellPrerequisiteKind" NOT NULL,
    "level" INTEGER,
    "class_feature_id" TEXT,
    "target_srd_index" TEXT,

    CONSTRAINT "subclass_spell_prerequisites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_levels" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "character_class_id" TEXT NOT NULL,
    "level" INTEGER NOT NULL,
    "prof_bonus" INTEGER NOT NULL,
    "ability_score_bonuses" INTEGER NOT NULL,
    "class_specific" JSONB,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',

    CONSTRAINT "class_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_level_spellcastings" (
    "id" TEXT NOT NULL,
    "class_level_id" TEXT NOT NULL,
    "cantrips_known" INTEGER,
    "spells_known" INTEGER,

    CONSTRAINT "class_level_spellcastings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_level_spell_slots" (
    "id" TEXT NOT NULL,
    "class_level_spellcasting_id" TEXT NOT NULL,
    "slot_level" INTEGER NOT NULL,
    "slots" INTEGER NOT NULL,

    CONSTRAINT "class_level_spell_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subclass_levels" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "subclass_id" TEXT NOT NULL,
    "level" INTEGER NOT NULL,
    "subclass_specific" JSONB,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',

    CONSTRAINT "subclass_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_resource_definitions" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "character_class_id" TEXT,
    "value_kind" "ClassResourceValueKind" NOT NULL,
    "label" TEXT NOT NULL,
    "supports_unlimited" BOOLEAN NOT NULL DEFAULT false,
    "consumable" BOOLEAN NOT NULL DEFAULT false,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "class_resource_definitions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_features" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "subclass_id" TEXT,
    "level" INTEGER NOT NULL,
    "grant_kind" "FeatureGrantKind" NOT NULL DEFAULT 'LEVEL_GRANT',
    "description" TEXT[],
    "parent_feature_id" TEXT,
    "reference_url" TEXT,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "class_features_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_feature_armor_formulas" (
    "id" TEXT NOT NULL,
    "class_feature_id" TEXT NOT NULL,
    "base" INTEGER NOT NULL DEFAULT 10,
    "abilities" "Ability"[],
    "allows_shield" BOOLEAN NOT NULL DEFAULT false,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "class_feature_armor_formulas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feature_prerequisites" (
    "id" TEXT NOT NULL,
    "class_feature_id" TEXT NOT NULL,
    "kind" "FeaturePrerequisiteKind" NOT NULL,
    "level" INTEGER,
    "target_feature_id" TEXT,
    "target_spell_id" TEXT,
    "target_url" TEXT,

    CONSTRAINT "feature_prerequisites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "racial_traits" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "parent_trait_id" TEXT,
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "racial_traits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "race_trait_grants" (
    "id" TEXT NOT NULL,
    "race_id" TEXT,
    "subrace_id" TEXT,
    "racial_trait_id" TEXT NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "race_trait_grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "race_languages" (
    "id" TEXT NOT NULL,
    "race_id" TEXT NOT NULL,
    "language_id" TEXT NOT NULL,

    CONSTRAINT "race_languages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ability_bonus_grants" (
    "id" TEXT NOT NULL,
    "race_id" TEXT,
    "subrace_id" TEXT,
    "ability" "Ability" NOT NULL,
    "bonus" INTEGER NOT NULL,

    CONSTRAINT "ability_bonus_grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "racial_trait_proficiencies" (
    "id" TEXT NOT NULL,
    "racial_trait_id" TEXT NOT NULL,
    "proficiency_id" TEXT NOT NULL,

    CONSTRAINT "racial_trait_proficiencies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "breath_weapon_details" (
    "id" TEXT NOT NULL,
    "racial_trait_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "area_of_effect_type" "AreaOfEffectType" NOT NULL,
    "area_of_effect_size_ft" INTEGER NOT NULL,
    "usage_interval" "UsageInterval" NOT NULL,
    "usage_times" INTEGER NOT NULL DEFAULT 1,
    "save_ability" "Ability" NOT NULL,
    "save_success" "SpellDcSuccess" NOT NULL DEFAULT 'HALF',
    "damage_type_id" TEXT NOT NULL,

    CONSTRAINT "breath_weapon_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "breath_weapon_damage_by_levels" (
    "id" TEXT NOT NULL,
    "breath_weapon_detail_id" TEXT NOT NULL,
    "character_level" INTEGER NOT NULL,
    "damage_dice" TEXT NOT NULL,

    CONSTRAINT "breath_weapon_damage_by_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "background_features" (
    "id" TEXT NOT NULL,
    "background_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT[],

    CONSTRAINT "background_features_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "background_proficiencies" (
    "id" TEXT NOT NULL,
    "background_id" TEXT NOT NULL,
    "proficiency_id" TEXT NOT NULL,

    CONSTRAINT "background_proficiencies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "background_starting_equipment_items" (
    "id" TEXT NOT NULL,
    "background_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "background_starting_equipment_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feats" (
    "id" TEXT NOT NULL,
    "srd_index" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "source" "ContentSource" NOT NULL DEFAULT 'SRD',
    "owner_id" TEXT,
    "visibility" "ContentVisibility" NOT NULL,
    "campaign_id" TEXT,
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "feats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feat_prerequisites" (
    "id" TEXT NOT NULL,
    "feat_id" TEXT NOT NULL,
    "ability" "Ability" NOT NULL,
    "minimum_score" INTEGER NOT NULL,

    CONSTRAINT "feat_prerequisites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "translations" (
    "id" TEXT NOT NULL,
    "entity_type" "TranslatableEntity" NOT NULL,
    "entity_id" TEXT NOT NULL,
    "locale" VARCHAR(10) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT[],
    "extra" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_class_levels" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "level" INTEGER NOT NULL DEFAULT 1,
    "subclass_id" TEXT,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "hit_points_rolled" INTEGER,
    "hit_dice_spent" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "character_class_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_proficiencies" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "proficiency_id" TEXT NOT NULL,
    "origin" "ProficiencyOrigin" NOT NULL,
    "expertise" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_proficiencies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_languages" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "language_id" TEXT NOT NULL,
    "origin" "GrantOrigin" NOT NULL,

    CONSTRAINT "character_languages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_spells" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "spell_id" TEXT NOT NULL,
    "origin" "GrantOrigin" NOT NULL DEFAULT 'CLASS',
    "character_class_id" TEXT,
    "subclass_id" TEXT,
    "prepared" BOOLEAN NOT NULL DEFAULT false,
    "always_prepared" BOOLEAN NOT NULL DEFAULT false,
    "usage_times" INTEGER,
    "usage_interval" "UsageInterval",
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "character_spells_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_features" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "class_feature_id" TEXT,
    "racial_trait_id" TEXT,
    "background_feature_id" TEXT,
    "background_id" TEXT,
    "feat_id" TEXT,
    "origin" "GrantOrigin" NOT NULL,
    "acquired_at_level" INTEGER,
    "usage_times" INTEGER,
    "usage_interval" "UsageInterval",
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_features_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_items" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "equipped" BOOLEAN NOT NULL DEFAULT false,
    "attuned" BOOLEAN NOT NULL DEFAULT false,
    "custom_name" TEXT,
    "notes" TEXT,
    "container_id" TEXT,
    "charges_remaining" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "inventory_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_conditions" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "condition_id" TEXT NOT NULL,
    "level" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_conditions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_spell_slots" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "slot_level" INTEGER NOT NULL,
    "expended" INTEGER NOT NULL DEFAULT 0,
    "is_pact_magic" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "character_spell_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_resource_usages" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "resource_definition_id" TEXT,
    "racial_trait_id" TEXT,
    "class_feature_id" TEXT,
    "character_spell_id" TEXT,
    "inventory_item_id" TEXT,
    "used" INTEGER NOT NULL DEFAULT 0,
    "max_override" INTEGER,
    "resets_on" "UsageInterval",
    "updated_at" TIMESTAMP(3) NOT NULL,
    "characterFeatureId" TEXT,

    CONSTRAINT "character_resource_usages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_active_effects" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "character_spell_id" TEXT NOT NULL,
    "requires_concentration" BOOLEAN NOT NULL DEFAULT false,
    "cast_at_slot_level" INTEGER,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),

    CONSTRAINT "character_active_effects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_ability_improvements" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "at_class_level" INTEGER NOT NULL,
    "kind" "AbilityImprovementKind" NOT NULL,
    "ability" "Ability",
    "amount" INTEGER,
    "feat_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_ability_improvements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_hit_point_modifiers" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "origin" "GrantOrigin" NOT NULL,
    "racial_trait_id" TEXT,
    "feat_id" TEXT,
    "flat_bonus" INTEGER NOT NULL DEFAULT 0,
    "per_level_bonus" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_hit_point_modifiers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_choice_selections" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "choice_id" TEXT NOT NULL,
    "choice_option_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_choice_selections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_drafts" (
    "id" TEXT NOT NULL,
    "current_step" "CharacterDraftStep" NOT NULL DEFAULT 'RACE',
    "name" TEXT,
    "strength" INTEGER DEFAULT 10,
    "dexterity" INTEGER DEFAULT 10,
    "constitution" INTEGER DEFAULT 10,
    "intelligence" INTEGER DEFAULT 10,
    "wisdom" INTEGER DEFAULT 10,
    "charisma" INTEGER DEFAULT 10,
    "user_id" TEXT NOT NULL,
    "race_id" TEXT,
    "subrace_id" TEXT,
    "background_id" TEXT,
    "alignment_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "character_drafts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_draft_class_levels" (
    "id" TEXT NOT NULL,
    "character_draft_id" TEXT NOT NULL,
    "character_class_id" TEXT NOT NULL,
    "level" INTEGER NOT NULL DEFAULT 1,
    "subclass_id" TEXT,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "character_draft_class_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_draft_selections" (
    "id" TEXT NOT NULL,
    "character_draft_id" TEXT NOT NULL,
    "choice_id" TEXT NOT NULL,
    "choice_option_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "character_draft_selections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaigns" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "owner_id" TEXT NOT NULL,
    "invite_code" TEXT,
    "invite_code_expires_at" TIMESTAMP(3),
    "invite_code_max_uses" INTEGER,
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_members" (
    "id" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "role" "CampaignRole" NOT NULL,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "left_at" TIMESTAMP(3),
    "joined_via_invite_code" TEXT,

    CONSTRAINT "campaign_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_credentials" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "credentials_invalidated_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_credentials_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ability_scores_srd_index_key" ON "ability_scores"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "ability_scores_ability_key" ON "ability_scores"("ability");

-- CreateIndex
CREATE UNIQUE INDEX "skills_srd_index_key" ON "skills"("srd_index");

-- CreateIndex
CREATE INDEX "skills_ability_idx" ON "skills"("ability");

-- CreateIndex
CREATE UNIQUE INDEX "damage_types_srd_index_key" ON "damage_types"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "magic_schools_srd_index_key" ON "magic_schools"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "conditions_srd_index_key" ON "conditions"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "alignments_srd_index_key" ON "alignments"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "proficiencies_srd_index_key" ON "proficiencies"("srd_index");

-- CreateIndex
CREATE INDEX "proficiencies_item_id_idx" ON "proficiencies"("item_id");

-- CreateIndex
CREATE INDEX "proficiencies_equipment_category_id_idx" ON "proficiencies"("equipment_category_id");

-- CreateIndex
CREATE INDEX "proficiencies_skill_id_idx" ON "proficiencies"("skill_id");

-- CreateIndex
CREATE INDEX "proficiencies_category_idx" ON "proficiencies"("category");

-- CreateIndex
CREATE UNIQUE INDEX "option_choices_srd_index_key" ON "option_choices"("srd_index");

-- CreateIndex
CREATE INDEX "option_choices_equipment_category_id_idx" ON "option_choices"("equipment_category_id");

-- CreateIndex
CREATE INDEX "option_choices_race_id_idx" ON "option_choices"("race_id");

-- CreateIndex
CREATE INDEX "option_choices_subrace_id_idx" ON "option_choices"("subrace_id");

-- CreateIndex
CREATE INDEX "option_choices_racial_trait_id_idx" ON "option_choices"("racial_trait_id");

-- CreateIndex
CREATE INDEX "option_choices_character_class_id_idx" ON "option_choices"("character_class_id");

-- CreateIndex
CREATE INDEX "option_choices_class_feature_id_idx" ON "option_choices"("class_feature_id");

-- CreateIndex
CREATE INDEX "option_choices_background_id_idx" ON "option_choices"("background_id");

-- CreateIndex
CREATE INDEX "option_choices_feat_id_idx" ON "option_choices"("feat_id");

-- CreateIndex
CREATE INDEX "choice_options_choice_id_idx" ON "choice_options"("choice_id");

-- CreateIndex
CREATE INDEX "choice_options_nested_choice_id_idx" ON "choice_options"("nested_choice_id");

-- CreateIndex
CREATE INDEX "choice_options_parent_option_id_idx" ON "choice_options"("parent_option_id");

-- CreateIndex
CREATE UNIQUE INDEX "choice_options_choice_id_sort_order_key" ON "choice_options"("choice_id", "sort_order");

-- CreateIndex
CREATE UNIQUE INDEX "choice_options_id_choice_id_key" ON "choice_options"("id", "choice_id");

-- CreateIndex
CREATE UNIQUE INDEX "choice_option_references_choice_option_id_key" ON "choice_option_references"("choice_option_id");

-- CreateIndex
CREATE INDEX "choice_option_references_item_id_idx" ON "choice_option_references"("item_id");

-- CreateIndex
CREATE INDEX "choice_option_references_equipment_category_id_idx" ON "choice_option_references"("equipment_category_id");

-- CreateIndex
CREATE INDEX "choice_option_references_proficiency_id_idx" ON "choice_option_references"("proficiency_id");

-- CreateIndex
CREATE INDEX "choice_option_references_skill_id_idx" ON "choice_option_references"("skill_id");

-- CreateIndex
CREATE INDEX "choice_option_references_language_id_idx" ON "choice_option_references"("language_id");

-- CreateIndex
CREATE INDEX "choice_option_references_spell_id_idx" ON "choice_option_references"("spell_id");

-- CreateIndex
CREATE INDEX "choice_option_references_racial_trait_id_idx" ON "choice_option_references"("racial_trait_id");

-- CreateIndex
CREATE INDEX "choice_option_references_class_feature_id_idx" ON "choice_option_references"("class_feature_id");

-- CreateIndex
CREATE INDEX "choice_option_references_subclass_id_idx" ON "choice_option_references"("subclass_id");

-- CreateIndex
CREATE INDEX "choice_option_alignments_alignment_id_idx" ON "choice_option_alignments"("alignment_id");

-- CreateIndex
CREATE UNIQUE INDEX "choice_option_alignments_choice_option_id_alignment_id_key" ON "choice_option_alignments"("choice_option_id", "alignment_id");

-- CreateIndex
CREATE UNIQUE INDEX "equipment_categories_srd_index_key" ON "equipment_categories"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "items_srd_index_key" ON "items"("srd_index");

-- CreateIndex
CREATE INDEX "items_based_on_item_id_idx" ON "items"("based_on_item_id");

-- CreateIndex
CREATE INDEX "items_owner_id_idx" ON "items"("owner_id");

-- CreateIndex
CREATE INDEX "items_campaign_id_idx" ON "items"("campaign_id");

-- CreateIndex
CREATE INDEX "items_item_kind_deleted_at_idx" ON "items"("item_kind", "deleted_at");

-- CreateIndex
CREATE INDEX "items_visibility_deleted_at_idx" ON "items"("visibility", "deleted_at");

-- CreateIndex
CREATE INDEX "items_source_deleted_at_idx" ON "items"("source", "deleted_at");

-- CreateIndex
CREATE INDEX "items_deleted_at_idx" ON "items"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "weapon_details_item_id_key" ON "weapon_details"("item_id");

-- CreateIndex
CREATE INDEX "weapon_details_damage_type_id_idx" ON "weapon_details"("damage_type_id");

-- CreateIndex
CREATE INDEX "weapon_details_two_handed_damage_type_id_idx" ON "weapon_details"("two_handed_damage_type_id");

-- CreateIndex
CREATE UNIQUE INDEX "armor_details_item_id_key" ON "armor_details"("item_id");

-- CreateIndex
CREATE UNIQUE INDEX "vehicle_details_item_id_key" ON "vehicle_details"("item_id");

-- CreateIndex
CREATE UNIQUE INDEX "magic_item_details_item_id_key" ON "magic_item_details"("item_id");

-- CreateIndex
CREATE INDEX "magic_item_details_rarity_idx" ON "magic_item_details"("rarity");

-- CreateIndex
CREATE INDEX "item_categories_equipment_category_id_idx" ON "item_categories"("equipment_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "item_categories_item_id_equipment_category_id_key" ON "item_categories"("item_id", "equipment_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "weapon_properties_srd_index_key" ON "weapon_properties"("srd_index");

-- CreateIndex
CREATE INDEX "item_weapon_properties_weapon_property_id_idx" ON "item_weapon_properties"("weapon_property_id");

-- CreateIndex
CREATE UNIQUE INDEX "item_weapon_properties_item_id_weapon_property_id_key" ON "item_weapon_properties"("item_id", "weapon_property_id");

-- CreateIndex
CREATE INDEX "item_pack_contents_item_id_idx" ON "item_pack_contents"("item_id");

-- CreateIndex
CREATE UNIQUE INDEX "item_pack_contents_pack_item_id_item_id_key" ON "item_pack_contents"("pack_item_id", "item_id");

-- CreateIndex
CREATE UNIQUE INDEX "spells_srd_index_key" ON "spells"("srd_index");

-- CreateIndex
CREATE INDEX "spells_magic_school_id_idx" ON "spells"("magic_school_id");

-- CreateIndex
CREATE INDEX "spells_damage_type_id_idx" ON "spells"("damage_type_id");

-- CreateIndex
CREATE INDEX "spells_owner_id_idx" ON "spells"("owner_id");

-- CreateIndex
CREATE INDEX "spells_campaign_id_idx" ON "spells"("campaign_id");

-- CreateIndex
CREATE INDEX "spells_level_deleted_at_idx" ON "spells"("level", "deleted_at");

-- CreateIndex
CREATE INDEX "spells_visibility_deleted_at_idx" ON "spells"("visibility", "deleted_at");

-- CreateIndex
CREATE INDEX "spells_source_deleted_at_idx" ON "spells"("source", "deleted_at");

-- CreateIndex
CREATE INDEX "spells_deleted_at_idx" ON "spells"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "spell_scalings_spell_id_kind_level_key" ON "spell_scalings"("spell_id", "kind", "level");

-- CreateIndex
CREATE INDEX "spell_classes_character_class_id_idx" ON "spell_classes"("character_class_id");

-- CreateIndex
CREATE UNIQUE INDEX "spell_classes_spell_id_character_class_id_key" ON "spell_classes"("spell_id", "character_class_id");

-- CreateIndex
CREATE INDEX "spell_subclasses_subclass_id_idx" ON "spell_subclasses"("subclass_id");

-- CreateIndex
CREATE UNIQUE INDEX "spell_subclasses_spell_id_subclass_id_key" ON "spell_subclasses"("spell_id", "subclass_id");

-- CreateIndex
CREATE UNIQUE INDEX "class_saving_throws_character_class_id_ability_key" ON "class_saving_throws"("character_class_id", "ability");

-- CreateIndex
CREATE INDEX "class_proficiency_grants_proficiency_id_idx" ON "class_proficiency_grants"("proficiency_id");

-- CreateIndex
CREATE UNIQUE INDEX "class_proficiency_grants_character_class_id_proficiency_id__key" ON "class_proficiency_grants"("character_class_id", "proficiency_id", "on_multiclass");

-- CreateIndex
CREATE INDEX "class_starting_equipment_items_item_id_idx" ON "class_starting_equipment_items"("item_id");

-- CreateIndex
CREATE UNIQUE INDEX "class_starting_equipment_items_character_class_id_item_id_key" ON "class_starting_equipment_items"("character_class_id", "item_id");

-- CreateIndex
CREATE UNIQUE INDEX "multiclass_prerequisites_character_class_id_ability_key" ON "multiclass_prerequisites"("character_class_id", "ability");

-- CreateIndex
CREATE UNIQUE INDEX "class_spellcastings_character_class_id_key" ON "class_spellcastings"("character_class_id");

-- CreateIndex
CREATE UNIQUE INDEX "subclasses_srd_index_key" ON "subclasses"("srd_index");

-- CreateIndex
CREATE INDEX "subclasses_character_class_id_idx" ON "subclasses"("character_class_id");

-- CreateIndex
CREATE UNIQUE INDEX "subclasses_id_character_class_id_key" ON "subclasses"("id", "character_class_id");

-- CreateIndex
CREATE INDEX "subclass_spells_spell_id_idx" ON "subclass_spells"("spell_id");

-- CreateIndex
CREATE UNIQUE INDEX "subclass_spells_subclass_id_spell_id_key" ON "subclass_spells"("subclass_id", "spell_id");

-- CreateIndex
CREATE INDEX "subclass_spell_prerequisites_subclass_spell_id_idx" ON "subclass_spell_prerequisites"("subclass_spell_id");

-- CreateIndex
CREATE INDEX "subclass_spell_prerequisites_class_feature_id_idx" ON "subclass_spell_prerequisites"("class_feature_id");

-- CreateIndex
CREATE UNIQUE INDEX "subclass_spell_prerequisites_subclass_spell_id_kind_level_c_key" ON "subclass_spell_prerequisites"("subclass_spell_id", "kind", "level", "class_feature_id");

-- CreateIndex
CREATE UNIQUE INDEX "class_levels_srd_index_key" ON "class_levels"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "class_levels_character_class_id_level_key" ON "class_levels"("character_class_id", "level");

-- CreateIndex
CREATE UNIQUE INDEX "class_level_spellcastings_class_level_id_key" ON "class_level_spellcastings"("class_level_id");

-- CreateIndex
CREATE UNIQUE INDEX "class_level_spell_slots_class_level_spellcasting_id_slot_le_key" ON "class_level_spell_slots"("class_level_spellcasting_id", "slot_level");

-- CreateIndex
CREATE UNIQUE INDEX "subclass_levels_srd_index_key" ON "subclass_levels"("srd_index");

-- CreateIndex
CREATE UNIQUE INDEX "subclass_levels_subclass_id_level_key" ON "subclass_levels"("subclass_id", "level");

-- CreateIndex
CREATE UNIQUE INDEX "class_resource_definitions_srd_index_key" ON "class_resource_definitions"("srd_index");

-- CreateIndex
CREATE INDEX "class_resource_definitions_character_class_id_idx" ON "class_resource_definitions"("character_class_id");

-- CreateIndex
CREATE UNIQUE INDEX "class_features_srd_index_key" ON "class_features"("srd_index");

-- CreateIndex
CREATE INDEX "class_features_character_class_id_level_subclass_id_idx" ON "class_features"("character_class_id", "level", "subclass_id");

-- CreateIndex
CREATE INDEX "class_features_subclass_id_idx" ON "class_features"("subclass_id");

-- CreateIndex
CREATE INDEX "class_features_parent_feature_id_idx" ON "class_features"("parent_feature_id");

-- CreateIndex
CREATE INDEX "class_features_grant_kind_idx" ON "class_features"("grant_kind");

-- CreateIndex
CREATE INDEX "class_features_deleted_at_idx" ON "class_features"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "class_feature_armor_formulas_class_feature_id_key" ON "class_feature_armor_formulas"("class_feature_id");

-- CreateIndex
CREATE INDEX "feature_prerequisites_class_feature_id_idx" ON "feature_prerequisites"("class_feature_id");

-- CreateIndex
CREATE INDEX "feature_prerequisites_target_feature_id_idx" ON "feature_prerequisites"("target_feature_id");

-- CreateIndex
CREATE INDEX "feature_prerequisites_target_spell_id_idx" ON "feature_prerequisites"("target_spell_id");

-- CreateIndex
CREATE UNIQUE INDEX "feature_prerequisites_class_feature_id_kind_level_target_fe_key" ON "feature_prerequisites"("class_feature_id", "kind", "level", "target_feature_id", "target_spell_id");

-- CreateIndex
CREATE UNIQUE INDEX "racial_traits_srd_index_key" ON "racial_traits"("srd_index");

-- CreateIndex
CREATE INDEX "racial_traits_parent_trait_id_idx" ON "racial_traits"("parent_trait_id");

-- CreateIndex
CREATE INDEX "racial_traits_deleted_at_idx" ON "racial_traits"("deleted_at");

-- CreateIndex
CREATE INDEX "race_trait_grants_racial_trait_id_idx" ON "race_trait_grants"("racial_trait_id");

-- CreateIndex
CREATE UNIQUE INDEX "race_trait_grants_race_id_racial_trait_id_key" ON "race_trait_grants"("race_id", "racial_trait_id");

-- CreateIndex
CREATE UNIQUE INDEX "race_trait_grants_subrace_id_racial_trait_id_key" ON "race_trait_grants"("subrace_id", "racial_trait_id");

-- CreateIndex
CREATE INDEX "race_languages_language_id_idx" ON "race_languages"("language_id");

-- CreateIndex
CREATE UNIQUE INDEX "race_languages_race_id_language_id_key" ON "race_languages"("race_id", "language_id");

-- CreateIndex
CREATE UNIQUE INDEX "ability_bonus_grants_race_id_ability_key" ON "ability_bonus_grants"("race_id", "ability");

-- CreateIndex
CREATE UNIQUE INDEX "ability_bonus_grants_subrace_id_ability_key" ON "ability_bonus_grants"("subrace_id", "ability");

-- CreateIndex
CREATE INDEX "racial_trait_proficiencies_proficiency_id_idx" ON "racial_trait_proficiencies"("proficiency_id");

-- CreateIndex
CREATE UNIQUE INDEX "racial_trait_proficiencies_racial_trait_id_proficiency_id_key" ON "racial_trait_proficiencies"("racial_trait_id", "proficiency_id");

-- CreateIndex
CREATE UNIQUE INDEX "breath_weapon_details_racial_trait_id_key" ON "breath_weapon_details"("racial_trait_id");

-- CreateIndex
CREATE INDEX "breath_weapon_details_damage_type_id_idx" ON "breath_weapon_details"("damage_type_id");

-- CreateIndex
CREATE UNIQUE INDEX "breath_weapon_damage_by_levels_breath_weapon_detail_id_char_key" ON "breath_weapon_damage_by_levels"("breath_weapon_detail_id", "character_level");

-- CreateIndex
CREATE UNIQUE INDEX "background_features_background_id_key" ON "background_features"("background_id");

-- CreateIndex
CREATE INDEX "background_proficiencies_proficiency_id_idx" ON "background_proficiencies"("proficiency_id");

-- CreateIndex
CREATE UNIQUE INDEX "background_proficiencies_background_id_proficiency_id_key" ON "background_proficiencies"("background_id", "proficiency_id");

-- CreateIndex
CREATE INDEX "background_starting_equipment_items_item_id_idx" ON "background_starting_equipment_items"("item_id");

-- CreateIndex
CREATE UNIQUE INDEX "background_starting_equipment_items_background_id_item_id_key" ON "background_starting_equipment_items"("background_id", "item_id");

-- CreateIndex
CREATE UNIQUE INDEX "feats_srd_index_key" ON "feats"("srd_index");

-- CreateIndex
CREATE INDEX "feats_owner_id_idx" ON "feats"("owner_id");

-- CreateIndex
CREATE INDEX "feats_campaign_id_idx" ON "feats"("campaign_id");

-- CreateIndex
CREATE INDEX "feats_visibility_deleted_at_idx" ON "feats"("visibility", "deleted_at");

-- CreateIndex
CREATE INDEX "feats_source_deleted_at_idx" ON "feats"("source", "deleted_at");

-- CreateIndex
CREATE INDEX "feats_deleted_at_idx" ON "feats"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "feat_prerequisites_feat_id_ability_key" ON "feat_prerequisites"("feat_id", "ability");

-- CreateIndex
CREATE INDEX "translations_entity_type_locale_name_idx" ON "translations"("entity_type", "locale", "name");

-- CreateIndex
CREATE UNIQUE INDEX "translations_entity_type_entity_id_locale_key" ON "translations"("entity_type", "entity_id", "locale");

-- CreateIndex
CREATE INDEX "character_class_levels_character_class_id_idx" ON "character_class_levels"("character_class_id");

-- CreateIndex
CREATE INDEX "character_class_levels_subclass_id_idx" ON "character_class_levels"("subclass_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_class_levels_character_id_character_class_id_key" ON "character_class_levels"("character_id", "character_class_id");

-- CreateIndex
CREATE INDEX "character_proficiencies_proficiency_id_idx" ON "character_proficiencies"("proficiency_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_proficiencies_character_id_proficiency_id_origin_key" ON "character_proficiencies"("character_id", "proficiency_id", "origin");

-- CreateIndex
CREATE INDEX "character_languages_language_id_idx" ON "character_languages"("language_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_languages_character_id_language_id_origin_key" ON "character_languages"("character_id", "language_id", "origin");

-- CreateIndex
CREATE INDEX "character_spells_spell_id_idx" ON "character_spells"("spell_id");

-- CreateIndex
CREATE INDEX "character_spells_character_class_id_idx" ON "character_spells"("character_class_id");

-- CreateIndex
CREATE INDEX "character_spells_subclass_id_idx" ON "character_spells"("subclass_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_spells_character_id_spell_id_origin_character_cla_key" ON "character_spells"("character_id", "spell_id", "origin", "character_class_id", "subclass_id");

-- CreateIndex
CREATE INDEX "character_features_character_id_origin_idx" ON "character_features"("character_id", "origin");

-- CreateIndex
CREATE INDEX "character_features_class_feature_id_idx" ON "character_features"("class_feature_id");

-- CreateIndex
CREATE INDEX "character_features_racial_trait_id_idx" ON "character_features"("racial_trait_id");

-- CreateIndex
CREATE INDEX "character_features_background_feature_id_idx" ON "character_features"("background_feature_id");

-- CreateIndex
CREATE INDEX "character_features_background_id_idx" ON "character_features"("background_id");

-- CreateIndex
CREATE INDEX "character_features_feat_id_idx" ON "character_features"("feat_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_features_character_id_class_feature_id_racial_tra_key" ON "character_features"("character_id", "class_feature_id", "racial_trait_id", "background_feature_id", "feat_id", "origin");

-- CreateIndex
CREATE INDEX "inventory_items_character_id_equipped_idx" ON "inventory_items"("character_id", "equipped");

-- CreateIndex
CREATE INDEX "inventory_items_item_id_idx" ON "inventory_items"("item_id");

-- CreateIndex
CREATE INDEX "inventory_items_container_id_idx" ON "inventory_items"("container_id");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_items_id_character_id_key" ON "inventory_items"("id", "character_id");

-- CreateIndex
CREATE INDEX "character_conditions_condition_id_idx" ON "character_conditions"("condition_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_conditions_character_id_condition_id_key" ON "character_conditions"("character_id", "condition_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_spell_slots_character_id_slot_level_is_pact_magic_key" ON "character_spell_slots"("character_id", "slot_level", "is_pact_magic");

-- CreateIndex
CREATE INDEX "character_resource_usages_resource_definition_id_idx" ON "character_resource_usages"("resource_definition_id");

-- CreateIndex
CREATE INDEX "character_resource_usages_racial_trait_id_idx" ON "character_resource_usages"("racial_trait_id");

-- CreateIndex
CREATE INDEX "character_resource_usages_class_feature_id_idx" ON "character_resource_usages"("class_feature_id");

-- CreateIndex
CREATE INDEX "character_resource_usages_character_spell_id_idx" ON "character_resource_usages"("character_spell_id");

-- CreateIndex
CREATE INDEX "character_resource_usages_inventory_item_id_idx" ON "character_resource_usages"("inventory_item_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_resource_usages_character_id_resource_definition__key" ON "character_resource_usages"("character_id", "resource_definition_id", "racial_trait_id", "class_feature_id", "character_spell_id", "inventory_item_id");

-- CreateIndex
CREATE INDEX "character_active_effects_character_id_requires_concentratio_idx" ON "character_active_effects"("character_id", "requires_concentration");

-- CreateIndex
CREATE INDEX "character_active_effects_character_spell_id_idx" ON "character_active_effects"("character_spell_id");

-- CreateIndex
CREATE INDEX "character_ability_improvements_character_id_idx" ON "character_ability_improvements"("character_id");

-- CreateIndex
CREATE INDEX "character_ability_improvements_character_class_id_idx" ON "character_ability_improvements"("character_class_id");

-- CreateIndex
CREATE INDEX "character_ability_improvements_feat_id_idx" ON "character_ability_improvements"("feat_id");

-- CreateIndex
CREATE INDEX "character_hit_point_modifiers_character_id_idx" ON "character_hit_point_modifiers"("character_id");

-- CreateIndex
CREATE INDEX "character_hit_point_modifiers_racial_trait_id_idx" ON "character_hit_point_modifiers"("racial_trait_id");

-- CreateIndex
CREATE INDEX "character_hit_point_modifiers_feat_id_idx" ON "character_hit_point_modifiers"("feat_id");

-- CreateIndex
CREATE INDEX "character_choice_selections_choice_id_idx" ON "character_choice_selections"("choice_id");

-- CreateIndex
CREATE INDEX "character_choice_selections_choice_option_id_idx" ON "character_choice_selections"("choice_option_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_choice_selections_character_id_choice_id_choice_o_key" ON "character_choice_selections"("character_id", "choice_id", "choice_option_id");

-- CreateIndex
CREATE INDEX "character_drafts_user_id_idx" ON "character_drafts"("user_id");

-- CreateIndex
CREATE INDEX "character_drafts_race_id_idx" ON "character_drafts"("race_id");

-- CreateIndex
CREATE INDEX "character_drafts_background_id_idx" ON "character_drafts"("background_id");

-- CreateIndex
CREATE INDEX "character_drafts_subrace_id_idx" ON "character_drafts"("subrace_id");

-- CreateIndex
CREATE INDEX "character_drafts_alignment_id_idx" ON "character_drafts"("alignment_id");

-- CreateIndex
CREATE INDEX "character_draft_class_levels_character_class_id_idx" ON "character_draft_class_levels"("character_class_id");

-- CreateIndex
CREATE INDEX "character_draft_class_levels_subclass_id_idx" ON "character_draft_class_levels"("subclass_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_draft_class_levels_character_draft_id_character_c_key" ON "character_draft_class_levels"("character_draft_id", "character_class_id");

-- CreateIndex
CREATE INDEX "character_draft_selections_choice_id_idx" ON "character_draft_selections"("choice_id");

-- CreateIndex
CREATE INDEX "character_draft_selections_choice_option_id_idx" ON "character_draft_selections"("choice_option_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_draft_selections_character_draft_id_choice_id_cho_key" ON "character_draft_selections"("character_draft_id", "choice_id", "choice_option_id");

-- CreateIndex
CREATE UNIQUE INDEX "campaigns_invite_code_key" ON "campaigns"("invite_code");

-- CreateIndex
CREATE INDEX "campaigns_owner_id_deleted_at_idx" ON "campaigns"("owner_id", "deleted_at");

-- CreateIndex
CREATE INDEX "campaigns_deleted_at_idx" ON "campaigns"("deleted_at");

-- CreateIndex
CREATE INDEX "campaign_members_user_id_idx" ON "campaign_members"("user_id");

-- CreateIndex
CREATE INDEX "campaign_members_campaign_id_role_idx" ON "campaign_members"("campaign_id", "role");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_members_campaign_id_user_id_key" ON "campaign_members"("campaign_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_credentials_user_id_key" ON "user_credentials"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "backgrounds_srd_index_key" ON "backgrounds"("srd_index");

-- CreateIndex
CREATE INDEX "backgrounds_owner_id_idx" ON "backgrounds"("owner_id");

-- CreateIndex
CREATE INDEX "backgrounds_campaign_id_idx" ON "backgrounds"("campaign_id");

-- CreateIndex
CREATE INDEX "backgrounds_visibility_deleted_at_idx" ON "backgrounds"("visibility", "deleted_at");

-- CreateIndex
CREATE INDEX "backgrounds_source_deleted_at_idx" ON "backgrounds"("source", "deleted_at");

-- CreateIndex
CREATE INDEX "backgrounds_deleted_at_idx" ON "backgrounds"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "character_classes_srd_index_key" ON "character_classes"("srd_index");

-- CreateIndex
CREATE INDEX "character_classes_owner_id_idx" ON "character_classes"("owner_id");

-- CreateIndex
CREATE INDEX "character_classes_campaign_id_idx" ON "character_classes"("campaign_id");

-- CreateIndex
CREATE INDEX "character_classes_visibility_deleted_at_idx" ON "character_classes"("visibility", "deleted_at");

-- CreateIndex
CREATE INDEX "character_classes_source_deleted_at_idx" ON "character_classes"("source", "deleted_at");

-- CreateIndex
CREATE INDEX "character_classes_deleted_at_idx" ON "character_classes"("deleted_at");

-- CreateIndex
CREATE INDEX "characters_user_id_deleted_at_idx" ON "characters"("user_id", "deleted_at");

-- CreateIndex
CREATE INDEX "characters_campaign_id_idx" ON "characters"("campaign_id");

-- CreateIndex
CREATE INDEX "characters_subrace_id_idx" ON "characters"("subrace_id");

-- CreateIndex
CREATE INDEX "characters_alignment_id_idx" ON "characters"("alignment_id");

-- CreateIndex
CREATE INDEX "characters_deleted_at_idx" ON "characters"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "languages_srd_index_key" ON "languages"("srd_index");

-- CreateIndex
CREATE INDEX "payments_status_created_at_idx" ON "payments"("status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "races_srd_index_key" ON "races"("srd_index");

-- CreateIndex
CREATE INDEX "races_owner_id_idx" ON "races"("owner_id");

-- CreateIndex
CREATE INDEX "races_campaign_id_idx" ON "races"("campaign_id");

-- CreateIndex
CREATE INDEX "races_visibility_deleted_at_idx" ON "races"("visibility", "deleted_at");

-- CreateIndex
CREATE INDEX "races_source_deleted_at_idx" ON "races"("source", "deleted_at");

-- CreateIndex
CREATE INDEX "races_deleted_at_idx" ON "races"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "subraces_srd_index_key" ON "subraces"("srd_index");

-- CreateIndex
CREATE INDEX "subraces_race_id_idx" ON "subraces"("race_id");

-- CreateIndex
CREATE INDEX "users_deleted_at_idx" ON "users"("deleted_at");

-- AddForeignKey
ALTER TABLE "proficiencies" ADD CONSTRAINT "proficiencies_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proficiencies" ADD CONSTRAINT "proficiencies_equipment_category_id_fkey" FOREIGN KEY ("equipment_category_id") REFERENCES "equipment_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proficiencies" ADD CONSTRAINT "proficiencies_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skills"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_equipment_category_id_fkey" FOREIGN KEY ("equipment_category_id") REFERENCES "equipment_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_race_id_fkey" FOREIGN KEY ("race_id") REFERENCES "races"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_subrace_id_fkey" FOREIGN KEY ("subrace_id") REFERENCES "subraces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_background_id_fkey" FOREIGN KEY ("background_id") REFERENCES "backgrounds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_choices" ADD CONSTRAINT "option_choices_feat_id_fkey" FOREIGN KEY ("feat_id") REFERENCES "feats"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_options" ADD CONSTRAINT "choice_options_choice_id_fkey" FOREIGN KEY ("choice_id") REFERENCES "option_choices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_options" ADD CONSTRAINT "choice_options_nested_choice_id_fkey" FOREIGN KEY ("nested_choice_id") REFERENCES "option_choices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_options" ADD CONSTRAINT "choice_options_parent_option_id_fkey" FOREIGN KEY ("parent_option_id") REFERENCES "choice_options"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_choice_option_id_fkey" FOREIGN KEY ("choice_option_id") REFERENCES "choice_options"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_equipment_category_id_fkey" FOREIGN KEY ("equipment_category_id") REFERENCES "equipment_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_proficiency_id_fkey" FOREIGN KEY ("proficiency_id") REFERENCES "proficiencies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skills"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_language_id_fkey" FOREIGN KEY ("language_id") REFERENCES "languages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "spells"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_references" ADD CONSTRAINT "choice_option_references_subclass_id_fkey" FOREIGN KEY ("subclass_id") REFERENCES "subclasses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_alignments" ADD CONSTRAINT "choice_option_alignments_choice_option_id_fkey" FOREIGN KEY ("choice_option_id") REFERENCES "choice_options"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "choice_option_alignments" ADD CONSTRAINT "choice_option_alignments_alignment_id_fkey" FOREIGN KEY ("alignment_id") REFERENCES "alignments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_based_on_item_id_fkey" FOREIGN KEY ("based_on_item_id") REFERENCES "items"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "weapon_details" ADD CONSTRAINT "weapon_details_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "weapon_details" ADD CONSTRAINT "weapon_details_damage_type_id_fkey" FOREIGN KEY ("damage_type_id") REFERENCES "damage_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "weapon_details" ADD CONSTRAINT "weapon_details_two_handed_damage_type_id_fkey" FOREIGN KEY ("two_handed_damage_type_id") REFERENCES "damage_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "armor_details" ADD CONSTRAINT "armor_details_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_details" ADD CONSTRAINT "vehicle_details_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "magic_item_details" ADD CONSTRAINT "magic_item_details_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_categories" ADD CONSTRAINT "item_categories_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_categories" ADD CONSTRAINT "item_categories_equipment_category_id_fkey" FOREIGN KEY ("equipment_category_id") REFERENCES "equipment_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_weapon_properties" ADD CONSTRAINT "item_weapon_properties_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_weapon_properties" ADD CONSTRAINT "item_weapon_properties_weapon_property_id_fkey" FOREIGN KEY ("weapon_property_id") REFERENCES "weapon_properties"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_pack_contents" ADD CONSTRAINT "item_pack_contents_pack_item_id_fkey" FOREIGN KEY ("pack_item_id") REFERENCES "items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_pack_contents" ADD CONSTRAINT "item_pack_contents_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spells" ADD CONSTRAINT "spells_magic_school_id_fkey" FOREIGN KEY ("magic_school_id") REFERENCES "magic_schools"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spells" ADD CONSTRAINT "spells_damage_type_id_fkey" FOREIGN KEY ("damage_type_id") REFERENCES "damage_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spells" ADD CONSTRAINT "spells_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spells" ADD CONSTRAINT "spells_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spell_scalings" ADD CONSTRAINT "spell_scalings_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "spells"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spell_classes" ADD CONSTRAINT "spell_classes_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "spells"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spell_classes" ADD CONSTRAINT "spell_classes_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spell_subclasses" ADD CONSTRAINT "spell_subclasses_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "spells"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spell_subclasses" ADD CONSTRAINT "spell_subclasses_subclass_id_fkey" FOREIGN KEY ("subclass_id") REFERENCES "subclasses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_classes" ADD CONSTRAINT "character_classes_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_classes" ADD CONSTRAINT "character_classes_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_saving_throws" ADD CONSTRAINT "class_saving_throws_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_proficiency_grants" ADD CONSTRAINT "class_proficiency_grants_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_proficiency_grants" ADD CONSTRAINT "class_proficiency_grants_proficiency_id_fkey" FOREIGN KEY ("proficiency_id") REFERENCES "proficiencies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_starting_equipment_items" ADD CONSTRAINT "class_starting_equipment_items_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_starting_equipment_items" ADD CONSTRAINT "class_starting_equipment_items_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "multiclass_prerequisites" ADD CONSTRAINT "multiclass_prerequisites_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_spellcastings" ADD CONSTRAINT "class_spellcastings_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subclasses" ADD CONSTRAINT "subclasses_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subclass_spells" ADD CONSTRAINT "subclass_spells_subclass_id_fkey" FOREIGN KEY ("subclass_id") REFERENCES "subclasses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subclass_spells" ADD CONSTRAINT "subclass_spells_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "spells"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subclass_spell_prerequisites" ADD CONSTRAINT "subclass_spell_prerequisites_subclass_spell_id_fkey" FOREIGN KEY ("subclass_spell_id") REFERENCES "subclass_spells"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subclass_spell_prerequisites" ADD CONSTRAINT "subclass_spell_prerequisites_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_levels" ADD CONSTRAINT "class_levels_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_level_spellcastings" ADD CONSTRAINT "class_level_spellcastings_class_level_id_fkey" FOREIGN KEY ("class_level_id") REFERENCES "class_levels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_level_spell_slots" ADD CONSTRAINT "class_level_spell_slots_class_level_spellcasting_id_fkey" FOREIGN KEY ("class_level_spellcasting_id") REFERENCES "class_level_spellcastings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subclass_levels" ADD CONSTRAINT "subclass_levels_subclass_id_fkey" FOREIGN KEY ("subclass_id") REFERENCES "subclasses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_resource_definitions" ADD CONSTRAINT "class_resource_definitions_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_features" ADD CONSTRAINT "class_features_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_features" ADD CONSTRAINT "class_features_subclass_id_character_class_id_fkey" FOREIGN KEY ("subclass_id", "character_class_id") REFERENCES "subclasses"("id", "character_class_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_features" ADD CONSTRAINT "class_features_parent_feature_id_fkey" FOREIGN KEY ("parent_feature_id") REFERENCES "class_features"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_feature_armor_formulas" ADD CONSTRAINT "class_feature_armor_formulas_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feature_prerequisites" ADD CONSTRAINT "feature_prerequisites_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feature_prerequisites" ADD CONSTRAINT "feature_prerequisites_target_feature_id_fkey" FOREIGN KEY ("target_feature_id") REFERENCES "class_features"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feature_prerequisites" ADD CONSTRAINT "feature_prerequisites_target_spell_id_fkey" FOREIGN KEY ("target_spell_id") REFERENCES "spells"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "races" ADD CONSTRAINT "races_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "races" ADD CONSTRAINT "races_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "racial_traits" ADD CONSTRAINT "racial_traits_parent_trait_id_fkey" FOREIGN KEY ("parent_trait_id") REFERENCES "racial_traits"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "race_trait_grants" ADD CONSTRAINT "race_trait_grants_race_id_fkey" FOREIGN KEY ("race_id") REFERENCES "races"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "race_trait_grants" ADD CONSTRAINT "race_trait_grants_subrace_id_fkey" FOREIGN KEY ("subrace_id") REFERENCES "subraces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "race_trait_grants" ADD CONSTRAINT "race_trait_grants_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "race_languages" ADD CONSTRAINT "race_languages_race_id_fkey" FOREIGN KEY ("race_id") REFERENCES "races"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "race_languages" ADD CONSTRAINT "race_languages_language_id_fkey" FOREIGN KEY ("language_id") REFERENCES "languages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ability_bonus_grants" ADD CONSTRAINT "ability_bonus_grants_race_id_fkey" FOREIGN KEY ("race_id") REFERENCES "races"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ability_bonus_grants" ADD CONSTRAINT "ability_bonus_grants_subrace_id_fkey" FOREIGN KEY ("subrace_id") REFERENCES "subraces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "racial_trait_proficiencies" ADD CONSTRAINT "racial_trait_proficiencies_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "racial_trait_proficiencies" ADD CONSTRAINT "racial_trait_proficiencies_proficiency_id_fkey" FOREIGN KEY ("proficiency_id") REFERENCES "proficiencies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "breath_weapon_details" ADD CONSTRAINT "breath_weapon_details_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "breath_weapon_details" ADD CONSTRAINT "breath_weapon_details_damage_type_id_fkey" FOREIGN KEY ("damage_type_id") REFERENCES "damage_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "breath_weapon_damage_by_levels" ADD CONSTRAINT "breath_weapon_damage_by_levels_breath_weapon_detail_id_fkey" FOREIGN KEY ("breath_weapon_detail_id") REFERENCES "breath_weapon_details"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "backgrounds" ADD CONSTRAINT "backgrounds_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "backgrounds" ADD CONSTRAINT "backgrounds_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "background_features" ADD CONSTRAINT "background_features_background_id_fkey" FOREIGN KEY ("background_id") REFERENCES "backgrounds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "background_proficiencies" ADD CONSTRAINT "background_proficiencies_background_id_fkey" FOREIGN KEY ("background_id") REFERENCES "backgrounds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "background_proficiencies" ADD CONSTRAINT "background_proficiencies_proficiency_id_fkey" FOREIGN KEY ("proficiency_id") REFERENCES "proficiencies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "background_starting_equipment_items" ADD CONSTRAINT "background_starting_equipment_items_background_id_fkey" FOREIGN KEY ("background_id") REFERENCES "backgrounds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "background_starting_equipment_items" ADD CONSTRAINT "background_starting_equipment_items_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feats" ADD CONSTRAINT "feats_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feats" ADD CONSTRAINT "feats_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feat_prerequisites" ADD CONSTRAINT "feat_prerequisites_feat_id_fkey" FOREIGN KEY ("feat_id") REFERENCES "feats"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "characters" ADD CONSTRAINT "characters_subrace_id_fkey" FOREIGN KEY ("subrace_id") REFERENCES "subraces"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "characters" ADD CONSTRAINT "characters_alignment_id_fkey" FOREIGN KEY ("alignment_id") REFERENCES "alignments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "characters" ADD CONSTRAINT "characters_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "characters" ADD CONSTRAINT "characters_campaign_id_user_id_fkey" FOREIGN KEY ("campaign_id", "user_id") REFERENCES "campaign_members"("campaign_id", "user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_class_levels" ADD CONSTRAINT "character_class_levels_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_class_levels" ADD CONSTRAINT "character_class_levels_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_class_levels" ADD CONSTRAINT "character_class_levels_subclass_id_character_class_id_fkey" FOREIGN KEY ("subclass_id", "character_class_id") REFERENCES "subclasses"("id", "character_class_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_proficiencies" ADD CONSTRAINT "character_proficiencies_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_proficiencies" ADD CONSTRAINT "character_proficiencies_proficiency_id_fkey" FOREIGN KEY ("proficiency_id") REFERENCES "proficiencies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_languages" ADD CONSTRAINT "character_languages_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_languages" ADD CONSTRAINT "character_languages_language_id_fkey" FOREIGN KEY ("language_id") REFERENCES "languages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_spells" ADD CONSTRAINT "character_spells_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_spells" ADD CONSTRAINT "character_spells_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "spells"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_spells" ADD CONSTRAINT "character_spells_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_spells" ADD CONSTRAINT "character_spells_subclass_id_character_class_id_fkey" FOREIGN KEY ("subclass_id", "character_class_id") REFERENCES "subclasses"("id", "character_class_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_features" ADD CONSTRAINT "character_features_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_features" ADD CONSTRAINT "character_features_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_features" ADD CONSTRAINT "character_features_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_features" ADD CONSTRAINT "character_features_background_feature_id_fkey" FOREIGN KEY ("background_feature_id") REFERENCES "background_features"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_features" ADD CONSTRAINT "character_features_background_id_fkey" FOREIGN KEY ("background_id") REFERENCES "backgrounds"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_features" ADD CONSTRAINT "character_features_feat_id_fkey" FOREIGN KEY ("feat_id") REFERENCES "feats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_items" ADD CONSTRAINT "inventory_items_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_items" ADD CONSTRAINT "inventory_items_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_items" ADD CONSTRAINT "inventory_items_container_id_character_id_fkey" FOREIGN KEY ("container_id", "character_id") REFERENCES "inventory_items"("id", "character_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_conditions" ADD CONSTRAINT "character_conditions_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_conditions" ADD CONSTRAINT "character_conditions_condition_id_fkey" FOREIGN KEY ("condition_id") REFERENCES "conditions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_spell_slots" ADD CONSTRAINT "character_spell_slots_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_resource_definition_id_fkey" FOREIGN KEY ("resource_definition_id") REFERENCES "class_resource_definitions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_class_feature_id_fkey" FOREIGN KEY ("class_feature_id") REFERENCES "class_features"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_character_spell_id_fkey" FOREIGN KEY ("character_spell_id") REFERENCES "character_spells"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_inventory_item_id_fkey" FOREIGN KEY ("inventory_item_id") REFERENCES "inventory_items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_resource_usages" ADD CONSTRAINT "character_resource_usages_characterFeatureId_fkey" FOREIGN KEY ("characterFeatureId") REFERENCES "character_features"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_active_effects" ADD CONSTRAINT "character_active_effects_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_active_effects" ADD CONSTRAINT "character_active_effects_character_spell_id_fkey" FOREIGN KEY ("character_spell_id") REFERENCES "character_spells"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_ability_improvements" ADD CONSTRAINT "character_ability_improvements_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_ability_improvements" ADD CONSTRAINT "character_ability_improvements_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_ability_improvements" ADD CONSTRAINT "character_ability_improvements_feat_id_fkey" FOREIGN KEY ("feat_id") REFERENCES "feats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_hit_point_modifiers" ADD CONSTRAINT "character_hit_point_modifiers_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_hit_point_modifiers" ADD CONSTRAINT "character_hit_point_modifiers_racial_trait_id_fkey" FOREIGN KEY ("racial_trait_id") REFERENCES "racial_traits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_hit_point_modifiers" ADD CONSTRAINT "character_hit_point_modifiers_feat_id_fkey" FOREIGN KEY ("feat_id") REFERENCES "feats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_choice_selections" ADD CONSTRAINT "character_choice_selections_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_choice_selections" ADD CONSTRAINT "character_choice_selections_choice_id_fkey" FOREIGN KEY ("choice_id") REFERENCES "option_choices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_choice_selections" ADD CONSTRAINT "character_choice_selections_choice_option_id_choice_id_fkey" FOREIGN KEY ("choice_option_id", "choice_id") REFERENCES "choice_options"("id", "choice_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_drafts" ADD CONSTRAINT "character_drafts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_drafts" ADD CONSTRAINT "character_drafts_race_id_fkey" FOREIGN KEY ("race_id") REFERENCES "races"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_drafts" ADD CONSTRAINT "character_drafts_subrace_id_fkey" FOREIGN KEY ("subrace_id") REFERENCES "subraces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_drafts" ADD CONSTRAINT "character_drafts_background_id_fkey" FOREIGN KEY ("background_id") REFERENCES "backgrounds"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_drafts" ADD CONSTRAINT "character_drafts_alignment_id_fkey" FOREIGN KEY ("alignment_id") REFERENCES "alignments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_draft_class_levels" ADD CONSTRAINT "character_draft_class_levels_character_draft_id_fkey" FOREIGN KEY ("character_draft_id") REFERENCES "character_drafts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_draft_class_levels" ADD CONSTRAINT "character_draft_class_levels_character_class_id_fkey" FOREIGN KEY ("character_class_id") REFERENCES "character_classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_draft_class_levels" ADD CONSTRAINT "character_draft_class_levels_subclass_id_character_class_i_fkey" FOREIGN KEY ("subclass_id", "character_class_id") REFERENCES "subclasses"("id", "character_class_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_draft_selections" ADD CONSTRAINT "character_draft_selections_character_draft_id_fkey" FOREIGN KEY ("character_draft_id") REFERENCES "character_drafts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_draft_selections" ADD CONSTRAINT "character_draft_selections_choice_id_fkey" FOREIGN KEY ("choice_id") REFERENCES "option_choices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_draft_selections" ADD CONSTRAINT "character_draft_selections_choice_option_id_choice_id_fkey" FOREIGN KEY ("choice_option_id", "choice_id") REFERENCES "choice_options"("id", "choice_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_members" ADD CONSTRAINT "campaign_members_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_members" ADD CONSTRAINT "campaign_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_credentials" ADD CONSTRAINT "user_credentials_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
