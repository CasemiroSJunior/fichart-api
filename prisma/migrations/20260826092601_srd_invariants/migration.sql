-- =============================================================================
-- SRD INVARIANTS
--
-- Everything Prisma cannot express, from the "WHAT THE RAW MIGRATION MUST ADD"
-- block at the top of prisma/schema.prisma. Until this file ran, several `///`
-- comments in the schema described a guarantee the database did not make.
--
-- Scope of this migration: sections A, B, C and part of E of that block.
-- Deliberately NOT here (see the notes at the bottom): section D and E.1.
--
-- Every table and column name below was read from the live database, not from
-- the schema file. Row counts cited in comments were verified against the JSON
-- in prisma/seed/data/en/.
-- =============================================================================


-- =============================================================================
-- A. CHECK CONSTRAINTS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- A.1  The six authorable catalogs: ownership and campaign visibility.
--
-- These are EQUIVALENCES (=), not implications. Read each as "exactly when":
--   a row is SRD  exactly when  it has no owner
--   a row is CAMPAIGN-visible  exactly when  it names a campaign
--
-- The first one is what closes the account-purge leak: without it, deleting a
-- user sets owner_id to NULL (Prisma's default for an optional relation), and a
-- row with no owner is precisely how this schema encodes "belongs to everyone".
-- Asking to delete your account would publish your private homebrew.
-- With the constraint, that UPDATE fails loudly instead.
-- -----------------------------------------------------------------------------

ALTER TABLE "items"
  ADD CONSTRAINT "items_srd_ownership_ck"
  CHECK ((source = 'SRD') = (owner_id IS NULL));
ALTER TABLE "items"
  ADD CONSTRAINT "items_campaign_visibility_ck"
  CHECK ((visibility = 'CAMPAIGN') = (campaign_id IS NOT NULL));

ALTER TABLE "spells"
  ADD CONSTRAINT "spells_srd_ownership_ck"
  CHECK ((source = 'SRD') = (owner_id IS NULL));
ALTER TABLE "spells"
  ADD CONSTRAINT "spells_campaign_visibility_ck"
  CHECK ((visibility = 'CAMPAIGN') = (campaign_id IS NOT NULL));

ALTER TABLE "character_classes"
  ADD CONSTRAINT "character_classes_srd_ownership_ck"
  CHECK ((source = 'SRD') = (owner_id IS NULL));
ALTER TABLE "character_classes"
  ADD CONSTRAINT "character_classes_campaign_visibility_ck"
  CHECK ((visibility = 'CAMPAIGN') = (campaign_id IS NOT NULL));

ALTER TABLE "races"
  ADD CONSTRAINT "races_srd_ownership_ck"
  CHECK ((source = 'SRD') = (owner_id IS NULL));
ALTER TABLE "races"
  ADD CONSTRAINT "races_campaign_visibility_ck"
  CHECK ((visibility = 'CAMPAIGN') = (campaign_id IS NOT NULL));

ALTER TABLE "backgrounds"
  ADD CONSTRAINT "backgrounds_srd_ownership_ck"
  CHECK ((source = 'SRD') = (owner_id IS NULL));
ALTER TABLE "backgrounds"
  ADD CONSTRAINT "backgrounds_campaign_visibility_ck"
  CHECK ((visibility = 'CAMPAIGN') = (campaign_id IS NOT NULL));

ALTER TABLE "feats"
  ADD CONSTRAINT "feats_srd_ownership_ck"
  CHECK ((source = 'SRD') = (owner_id IS NULL));
ALTER TABLE "feats"
  ADD CONSTRAINT "feats_campaign_visibility_ck"
  CHECK ((visibility = 'CAMPAIGN') = (campaign_id IS NOT NULL));


-- -----------------------------------------------------------------------------
-- A.2  option_choices: at most one owner.
--
-- `<= 1`, not `= 1`. A NESTED choice (a choice inside another choice, which the
-- Fighter's starting equipment really does contain) hangs off its parent option
-- and legitimately has no owner of its own.
-- -----------------------------------------------------------------------------

ALTER TABLE "option_choices"
  ADD CONSTRAINT "option_choices_single_owner_ck"
  CHECK (num_nonnulls(
    race_id, subrace_id, racial_trait_id, character_class_id,
    class_feature_id, background_id, feat_id
  ) <= 1);


-- -----------------------------------------------------------------------------
-- A.3 / A.4  Grants belong to a race OR a subrace, never both, never neither.
-- -----------------------------------------------------------------------------

ALTER TABLE "race_trait_grants"
  ADD CONSTRAINT "race_trait_grants_single_owner_ck"
  CHECK (num_nonnulls(race_id, subrace_id) = 1);

ALTER TABLE "ability_bonus_grants"
  ADD CONSTRAINT "ability_bonus_grants_single_owner_ck"
  CHECK (num_nonnulls(race_id, subrace_id) = 1);


-- -----------------------------------------------------------------------------
-- A.5  proficiencies: exactly one target.
--
-- Verified against Proficiencies.json before writing `= 1`: all 117 rows carry
-- exactly one reference — 85 to equipment, 18 to skills, 8 to equipment
-- categories, 6 to ability scores (saving throws). 85+18+8+6 = 117, no row with
-- zero and no row with two. The strict form is safe for the seed.
-- -----------------------------------------------------------------------------

ALTER TABLE "proficiencies"
  ADD CONSTRAINT "proficiencies_single_target_ck"
  CHECK (num_nonnulls(item_id, equipment_category_id, skill_id, saving_throw) = 1);


-- -----------------------------------------------------------------------------
-- A.6  choice_option_references: exactly one of the ten targets.
-- `ability` is an enum column rather than a foreign key, but it is a branch of
-- the same arc and counts.
-- -----------------------------------------------------------------------------

ALTER TABLE "choice_option_references"
  ADD CONSTRAINT "choice_option_references_single_target_ck"
  CHECK (num_nonnulls(
    item_id, equipment_category_id, proficiency_id, skill_id, language_id,
    spell_id, racial_trait_id, class_feature_id, subclass_id, ability
  ) = 1);


-- -----------------------------------------------------------------------------
-- A.7  character_features: a feature comes from exactly one place.
--
-- background_id is intentionally excluded: it is a denormalized lookup helper
-- that travels alongside background_feature_id, not a branch of the arc.
-- -----------------------------------------------------------------------------

ALTER TABLE "character_features"
  ADD CONSTRAINT "character_features_single_source_ck"
  CHECK (num_nonnulls(
    class_feature_id, racial_trait_id, background_feature_id, feat_id
  ) = 1);


-- -----------------------------------------------------------------------------
-- A.8  character_resource_usages: consumption belongs to exactly one thing.
-- -----------------------------------------------------------------------------

ALTER TABLE "character_resource_usages"
  ADD CONSTRAINT "character_resource_usages_single_owner_ck"
  CHECK (num_nonnulls(
    resource_definition_id, racial_trait_id, class_feature_id,
    character_spell_id, inventory_item_id
  ) = 1);


-- -----------------------------------------------------------------------------
-- A.9  character_ability_improvements: the two kinds are mutually exclusive.
--
-- At levels 4/8/12/16/19 a character raises ability scores OR takes a feat —
-- never both, never neither. Each branch also forbids the other's columns, so a
-- half-migrated row cannot masquerade as valid.
-- -----------------------------------------------------------------------------

ALTER TABLE "character_ability_improvements"
  ADD CONSTRAINT "character_ability_improvements_kind_ck"
  CHECK (
    (kind = 'ASI'  AND ability IS NOT NULL AND amount IS NOT NULL AND feat_id IS NULL)
    OR
    (kind = 'FEAT' AND feat_id IS NOT NULL AND ability IS NULL AND amount IS NULL)
  );


-- -----------------------------------------------------------------------------
-- A.10  Range checks.
-- Spell levels run 1..9. Level 0 is a cantrip and has no slot, so 0 here would
-- be a bug, not a cantrip.
-- -----------------------------------------------------------------------------

ALTER TABLE "option_choices"
  ADD CONSTRAINT "option_choices_choose_count_ck"
  CHECK (choose_count >= 1);

ALTER TABLE "class_level_spell_slots"
  ADD CONSTRAINT "class_level_spell_slots_slot_level_ck"
  CHECK (slot_level BETWEEN 1 AND 9);


-- =============================================================================
-- B. UNIQUE ... NULLS NOT DISTINCT
--
-- SQL says NULL is not equal to NULL, so a unique index over nullable columns
-- never reports a collision: you can insert the same tuple a thousand times and
-- the constraint stays silent. Every unique below spans an exclusive arc, so it
-- protects nothing as Prisma emits it.
--
-- PostgreSQL 15 added NULLS NOT DISTINCT, which makes NULLs compare equal for
-- uniqueness. This database is 17.11.
--
-- The index names are kept byte-for-byte so Prisma keeps recognizing them as
-- the indexes its @@unique declarations asked for.
-- =============================================================================

DROP INDEX "character_spells_character_id_spell_id_origin_character_cla_key";
CREATE UNIQUE INDEX "character_spells_character_id_spell_id_origin_character_cla_key"
  ON "character_spells" (character_id, spell_id, origin, character_class_id, subclass_id)
  NULLS NOT DISTINCT;

DROP INDEX "character_features_character_id_class_feature_id_racial_tra_key";
CREATE UNIQUE INDEX "character_features_character_id_class_feature_id_racial_tra_key"
  ON "character_features" (character_id, class_feature_id, racial_trait_id,
                           background_feature_id, feat_id, origin)
  NULLS NOT DISTINCT;

DROP INDEX "character_resource_usages_character_id_resource_definition__key";
CREATE UNIQUE INDEX "character_resource_usages_character_id_resource_definition__key"
  ON "character_resource_usages" (character_id, resource_definition_id, racial_trait_id,
                                  class_feature_id, character_spell_id, inventory_item_id)
  NULLS NOT DISTINCT;

DROP INDEX "feature_prerequisites_class_feature_id_kind_level_target_fe_key";
CREATE UNIQUE INDEX "feature_prerequisites_class_feature_id_kind_level_target_fe_key"
  ON "feature_prerequisites" (class_feature_id, kind, level, target_feature_id, target_spell_id)
  NULLS NOT DISTINCT;

DROP INDEX "subclass_spell_prerequisites_subclass_spell_id_kind_level_c_key";
CREATE UNIQUE INDEX "subclass_spell_prerequisites_subclass_spell_id_kind_level_c_key"
  ON "subclass_spell_prerequisites" (subclass_spell_id, kind, level, class_feature_id)
  NULLS NOT DISTINCT;


-- =============================================================================
-- C. PARTIAL UNIQUE INDEXES — "at most one row where X"
--
-- A plain unique index cannot say "only one of these may be true". A partial
-- unique index indexes only the rows matching WHERE, so uniqueness applies to
-- that subset and the remaining rows are unconstrained.
-- =============================================================================

-- A multiclass character has many class levels but exactly one primary class:
-- the one that decides starting proficiencies and starting equipment.
CREATE UNIQUE INDEX "character_class_levels_one_primary_uq"
  ON "character_class_levels" (character_id)
  WHERE is_primary;

CREATE UNIQUE INDEX "character_draft_class_levels_one_primary_uq"
  ON "character_draft_class_levels" (character_draft_id)
  WHERE is_primary;

-- Concentration is the rule this enforces: a character may concentrate on at
-- most one spell at a time. Casting a second one ends the first — which is an
-- application decision, but the database refuses to hold both either way.
CREATE UNIQUE INDEX "character_active_effects_one_concentration_uq"
  ON "character_active_effects" (character_id)
  WHERE requires_concentration;


-- =============================================================================
-- E. TRIGGER — a campaign may never lose its last GM
--
-- Deleting a CampaignMember row, demoting it to PLAYER, or marking left_at are
-- three different ways to reach the same broken state: a campaign nobody can
-- administer. One guard covers all three, and it lives in the database so that
-- a manual UPDATE in psql cannot bypass it either.
--
-- "Active GM" means role = 'GM' AND left_at IS NULL. A member who already left
-- is not protected, and removing their row is always allowed.
-- =============================================================================

CREATE OR REPLACE FUNCTION campaign_require_active_gm() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE
  remaining integer;
BEGIN
  -- Was the row being changed an active GM? If not, nothing is being lost.
  IF NOT (OLD.role = 'GM' AND OLD.left_at IS NULL) THEN
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
  END IF;

  -- On UPDATE, is it still an active GM afterwards? Then nothing is lost either.
  IF TG_OP = 'UPDATE' AND NEW.role = 'GM' AND NEW.left_at IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT count(*) INTO remaining
  FROM campaign_members
  WHERE campaign_id = OLD.campaign_id
    AND role = 'GM'
    AND left_at IS NULL
    AND id <> OLD.id;

  IF remaining = 0 THEN
    RAISE EXCEPTION
      'campaign % would be left without an active GM', OLD.campaign_id
      USING ERRCODE = 'check_violation';
  END IF;

  IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$;

CREATE TRIGGER campaign_members_require_active_gm
  BEFORE DELETE OR UPDATE ON "campaign_members"
  FOR EACH ROW
  EXECUTE FUNCTION campaign_require_active_gm();


-- =============================================================================
-- DELIBERATELY NOT IN THIS MIGRATION
--
-- D. Narrowing the 27 plain deleted_at indexes to partial ones
--    (WHERE deleted_at IS NOT NULL for the purge job, WHERE deleted_at IS NULL
--    for the browse paths). That is a performance change, not an integrity one:
--    a plain btree still answers both queries, it is merely larger. Index shape
--    is worth measuring against real query plans rather than guessing, and 27
--    DROP/CREATE pairs would have made this migration hard to review. It belongs
--    in its own migration, after the seed exists and there are rows to measure.
--
-- E.1 The "campaign creator automatically becomes a GM member" rule.
--     Implement it in the service layer, inside the same Prisma transaction that
--     creates the campaign — not as a trigger. Two reasons: ids in this schema
--     are UUIDv7 generated by Prisma, and a trigger would have to fall back to
--     gen_random_uuid() (v4), quietly breaking the time-ordering the whole
--     schema chose v7 for; and a trigger that inserts rows Prisma did not ask
--     for surprises anyone reading a `create` call. The guard above already
--     prevents the dangerous half of the rule.
-- =============================================================================
