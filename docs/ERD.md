```mermaid
erDiagram

        Ability {
            STR STR
DEX DEX
CON CON
INT INT
WIS WIS
CHA CHA
        }
    


        Size {
            TINY TINY
SMALL SMALL
MEDIUM MEDIUM
LARGE LARGE
HUGE HUGE
GARGANTUAN GARGANTUAN
        }
    


        ContentSource {
            SRD SRD
HOMEBREW HOMEBREW
        }
    


        ContentVisibility {
            PRIVATE PRIVATE
CAMPAIGN CAMPAIGN
PUBLIC PUBLIC
        }
    


        TranslatableEntity {
            ABILITY_SCORE ABILITY_SCORE
SKILL SKILL
DAMAGE_TYPE DAMAGE_TYPE
MAGIC_SCHOOL MAGIC_SCHOOL
CONDITION CONDITION
ALIGNMENT ALIGNMENT
LANGUAGE LANGUAGE
PROFICIENCY PROFICIENCY
EQUIPMENT_CATEGORY EQUIPMENT_CATEGORY
WEAPON_PROPERTY WEAPON_PROPERTY
ITEM ITEM
SPELL SPELL
CHARACTER_CLASS CHARACTER_CLASS
SUBCLASS SUBCLASS
CLASS_FEATURE CLASS_FEATURE
CLASS_RESOURCE_DEFINITION CLASS_RESOURCE_DEFINITION
RACE RACE
SUBRACE SUBRACE
RACIAL_TRAIT RACIAL_TRAIT
BACKGROUND BACKGROUND
FEAT FEAT
        }
    


        ItemKind {
            WEAPON WEAPON
ARMOR ARMOR
GEAR GEAR
TOOL TOOL
VEHICLE VEHICLE
MAGIC MAGIC
        }
    


        WeaponCategory {
            SIMPLE SIMPLE
MARTIAL MARTIAL
        }
    


        WeaponRange {
            MELEE MELEE
RANGED RANGED
        }
    


        ArmorCategory {
            LIGHT LIGHT
MEDIUM MEDIUM
HEAVY HEAVY
SHIELD SHIELD
        }
    


        ToolCategory {
            ARTISANS_TOOLS ARTISANS_TOOLS
GAMING_SET GAMING_SET
MUSICAL_INSTRUMENT MUSICAL_INSTRUMENT
OTHER OTHER
        }
    


        VehicleCategory {
            MOUNT_OR_ANIMAL MOUNT_OR_ANIMAL
TACK_HARNESS_DRAWN TACK_HARNESS_DRAWN
WATERBORNE WATERBORNE
        }
    


        SpeedUnit {
            FEET_PER_ROUND FEET_PER_ROUND
MILES_PER_HOUR MILES_PER_HOUR
        }
    


        MagicItemRarity {
            COMMON COMMON
UNCOMMON UNCOMMON
RARE RARE
VERY_RARE VERY_RARE
LEGENDARY LEGENDARY
ARTIFACT ARTIFACT
VARIES VARIES
        }
    


        SpellAttackType {
            MELEE MELEE
RANGED RANGED
        }
    


        SpellDcSuccess {
            NONE NONE
HALF HALF
OTHER OTHER
        }
    


        SpellScalingKind {
            DAMAGE_BY_SLOT DAMAGE_BY_SLOT
DAMAGE_BY_CHARACTER_LEVEL DAMAGE_BY_CHARACTER_LEVEL
HEAL_BY_SLOT HEAL_BY_SLOT
        }
    


        AreaOfEffectType {
            SPHERE SPHERE
CUBE CUBE
CYLINDER CYLINDER
LINE LINE
CONE CONE
        }
    


        CasterKind {
            FULL FULL
HALF HALF
THIRD THIRD
PACT PACT
        }
    


        SpellPreparationMode {
            KNOWN KNOWN
PREPARED_FROM_LIST PREPARED_FROM_LIST
PREPARED_FROM_SPELLBOOK PREPARED_FROM_SPELLBOOK
        }
    


        AbilityImprovementKind {
            ASI ASI
FEAT FEAT
        }
    


        ClassResourceValueKind {
            COUNT COUNT
DIE_FACE DIE_FACE
DICE DICE
FLAG FLAG
CHALLENGE_RATING CHALLENGE_RATING
SLOT_COST_TABLE SLOT_COST_TABLE
        }
    


        FeatureGrantKind {
            LEVEL_GRANT LEVEL_GRANT
OPTION OPTION
CONTAINER CONTAINER
        }
    


        FeaturePrerequisiteKind {
            LEVEL LEVEL
FEATURE FEATURE
SPELL SPELL
        }
    


        SubclassSpellPrerequisiteKind {
            LEVEL LEVEL
FEATURE FEATURE
        }
    


        ProficiencyCategory {
            ARMOR ARMOR
WEAPON WEAPON
ARTISANS_TOOLS ARTISANS_TOOLS
GAMING_SET GAMING_SET
MUSICAL_INSTRUMENT MUSICAL_INSTRUMENT
VEHICLE VEHICLE
SAVING_THROW SAVING_THROW
SKILL SKILL
OTHER OTHER
        }
    


        ProficiencyOrigin {
            RACE RACE
SUBRACE SUBRACE
CLASS CLASS
SUBCLASS SUBCLASS
BACKGROUND BACKGROUND
FEAT FEAT
OTHER OTHER
        }
    


        GrantOrigin {
            RACE RACE
SUBRACE SUBRACE
CLASS CLASS
SUBCLASS SUBCLASS
BACKGROUND BACKGROUND
FEAT FEAT
ITEM ITEM
CHOICE CHOICE
OTHER OTHER
        }
    


        LanguageRarity {
            STANDARD STANDARD
EXOTIC EXOTIC
        }
    


        LanguageScript {
            COMMON COMMON
DWARVISH DWARVISH
ELVISH ELVISH
INFERNAL INFERNAL
CELESTIAL CELESTIAL
DRACONIC DRACONIC
        }
    


        ChoiceKind {
            PROFICIENCY PROFICIENCY
EXPERTISE EXPERTISE
LANGUAGE LANGUAGE
ABILITY_BONUS ABILITY_BONUS
ABILITY_SCORE_PREREQUISITE ABILITY_SCORE_PREREQUISITE
EQUIPMENT EQUIPMENT
SPELL SPELL
TRAIT TRAIT
FEATURE FEATURE
ENEMY_TYPE ENEMY_TYPE
TERRAIN_TYPE TERRAIN_TYPE
PERSONALITY_TRAIT PERSONALITY_TRAIT
IDEAL IDEAL
BOND BOND
FLAW FLAW
        }
    


        ChoiceAnchor {
            RACE_LANGUAGE RACE_LANGUAGE
RACE_ABILITY_BONUS RACE_ABILITY_BONUS
SUBRACE_LANGUAGE SUBRACE_LANGUAGE
SUBRACE_ABILITY_BONUS SUBRACE_ABILITY_BONUS
TRAIT_PROFICIENCY TRAIT_PROFICIENCY
TRAIT_LANGUAGE TRAIT_LANGUAGE
TRAIT_SPELL TRAIT_SPELL
TRAIT_SUBTRAIT TRAIT_SUBTRAIT
CLASS_PROFICIENCY CLASS_PROFICIENCY
CLASS_EQUIPMENT CLASS_EQUIPMENT
MULTICLASS_PROFICIENCY MULTICLASS_PROFICIENCY
MULTICLASS_PREREQUISITE MULTICLASS_PREREQUISITE
FEATURE_EXPERTISE FEATURE_EXPERTISE
FEATURE_SUBFEATURE FEATURE_SUBFEATURE
FEATURE_ENEMY_TYPE FEATURE_ENEMY_TYPE
FEATURE_TERRAIN_TYPE FEATURE_TERRAIN_TYPE
BACKGROUND_PROFICIENCY BACKGROUND_PROFICIENCY
BACKGROUND_LANGUAGE BACKGROUND_LANGUAGE
BACKGROUND_EQUIPMENT BACKGROUND_EQUIPMENT
BACKGROUND_PERSONALITY_TRAIT BACKGROUND_PERSONALITY_TRAIT
BACKGROUND_IDEAL BACKGROUND_IDEAL
BACKGROUND_BOND BACKGROUND_BOND
BACKGROUND_FLAW BACKGROUND_FLAW
FEAT_PROFICIENCY FEAT_PROFICIENCY
FEAT_ABILITY_BONUS FEAT_ABILITY_BONUS
FEAT_LANGUAGE FEAT_LANGUAGE
NESTED NESTED
        }
    


        OptionSetType {
            OPTIONS_ARRAY OPTIONS_ARRAY
EQUIPMENT_CATEGORY EQUIPMENT_CATEGORY
RESOURCE_LIST RESOURCE_LIST
        }
    


        ChoiceOptionType {
            REFERENCE REFERENCE
COUNTED_REFERENCE COUNTED_REFERENCE
CHOICE CHOICE
MULTIPLE MULTIPLE
TEXT TEXT
ABILITY_BONUS ABILITY_BONUS
ABILITY_SCORE_PREREQUISITE ABILITY_SCORE_PREREQUISITE
IDEAL IDEAL
        }
    


        ChoiceTargetType {
            ITEM ITEM
EQUIPMENT_CATEGORY EQUIPMENT_CATEGORY
PROFICIENCY PROFICIENCY
SKILL SKILL
LANGUAGE LANGUAGE
SPELL SPELL
RACIAL_TRAIT RACIAL_TRAIT
CLASS_FEATURE CLASS_FEATURE
SUBCLASS SUBCLASS
ABILITY_SCORE ABILITY_SCORE
        }
    


        UsageInterval {
            PER_TURN PER_TURN
PER_REST PER_REST
PER_DAY PER_DAY
        }
    


        CampaignRole {
            GM GM
PLAYER PLAYER
        }
    


        CharacterDraftStep {
            RACE RACE
CHARACTER_CLASS CHARACTER_CLASS
ABILITY_SCORES ABILITY_SCORES
BACKGROUND BACKGROUND
EQUIPMENT EQUIPMENT
        }
    


        PaymentStatus {
            PENDING PENDING
PAID PAID
EXPIRED EXPIRED
CANCELLED CANCELLED
REFUNDED REFUNDED
        }
    


        Currency {
            BRL BRL
USD USD
EUR EUR
        }
    


        SheetVisibility {
            PRIVATE PRIVATE
CAMPAIGN CAMPAIGN
PUBLIC PUBLIC
        }
    
  "ability_scores" {
    String id "🗝️"
    String srd_index "❓"
    Ability ability 
    String abbreviation 
    String full_name 
    String description 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "skills" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    Ability ability 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "damage_types" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "magic_schools" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "conditions" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    Boolean is_graded 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "alignments" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String abbreviation 
    String description 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "languages" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    LanguageRarity rarity 
    LanguageScript script "❓"
    String typical_speakers 
    String description 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "proficiencies" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    ProficiencyCategory category 
    String item_id "❓"
    String equipment_category_id "❓"
    String skill_id "❓"
    Ability saving_throw "❓"
    String target_srd_index "❓"
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "option_choices" {
    String id "🗝️"
    String srd_index "❓"
    Int choose_count 
    ChoiceKind kind 
    String description "❓"
    OptionSetType option_set_type 
    String equipment_category_id "❓"
    String resource_list_url "❓"
    ChoiceAnchor anchor 
    Int sort_order 
    String race_id "❓"
    String subrace_id "❓"
    String racial_trait_id "❓"
    String character_class_id "❓"
    String class_feature_id "❓"
    String background_id "❓"
    String feat_id "❓"
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "choice_options" {
    String id "🗝️"
    String choice_id 
    Int sort_order 
    ChoiceOptionType option_type 
    String nested_choice_id "❓"
    String parent_option_id "❓"
    String text_value "❓"
    Ability ability "❓"
    Int numeric_value "❓"
    }
  

  "choice_option_references" {
    String id "🗝️"
    String choice_option_id 
    ChoiceTargetType target_type 
    String target_srd_index 
    Int count "❓"
    String item_id "❓"
    String equipment_category_id "❓"
    String proficiency_id "❓"
    String skill_id "❓"
    String language_id "❓"
    String spell_id "❓"
    String racial_trait_id "❓"
    String class_feature_id "❓"
    String subclass_id "❓"
    Ability ability "❓"
    }
  

  "choice_option_alignments" {
    String id "🗝️"
    String choice_option_id 
    String alignment_id 
    }
  

  "equipment_categories" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "items" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    ItemKind item_kind 
    Int cost_cp "❓"
    Int weight_centi_lb "❓"
    Int quantity_per_cost "❓"
    ToolCategory tool_category "❓"
    String description 
    String image_url "❓"
    String based_on_item_id "❓"
    ContentSource source 
    String owner_id "❓"
    ContentVisibility visibility 
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "weapon_details" {
    String id "🗝️"
    String item_id 
    WeaponCategory weapon_category 
    WeaponRange weapon_range 
    String damage_dice "❓"
    String damage_type_id "❓"
    String two_handed_damage_dice "❓"
    String two_handed_damage_type_id "❓"
    Int range_normal 
    Int range_long "❓"
    Int throw_range_normal "❓"
    Int throw_range_long "❓"
    String special 
    }
  

  "armor_details" {
    String id "🗝️"
    String item_id 
    ArmorCategory armor_category 
    Int ac_base 
    Boolean ac_dex_bonus 
    Int ac_max_bonus "❓"
    Int str_minimum 
    Boolean stealth_disadvantage 
    }
  

  "vehicle_details" {
    String id "🗝️"
    String item_id 
    VehicleCategory vehicle_category 
    Int speed_centi_value "❓"
    SpeedUnit speed_unit "❓"
    Int capacity_lb "❓"
    }
  

  "magic_item_details" {
    String id "🗝️"
    String item_id 
    MagicItemRarity rarity 
    Boolean requires_attunement "❓"
    }
  

  "item_categories" {
    String id "🗝️"
    String item_id 
    String equipment_category_id 
    }
  

  "weapon_properties" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "item_weapon_properties" {
    String id "🗝️"
    String item_id 
    String weapon_property_id 
    }
  

  "item_pack_contents" {
    String id "🗝️"
    String pack_item_id 
    String item_id 
    Int quantity 
    }
  

  "spells" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    Int level 
    String casting_time 
    String range_text 
    String duration_text 
    Boolean requires_verbal 
    Boolean requires_somatic 
    Boolean requires_material 
    String material_description "❓"
    Boolean ritual 
    Boolean concentration 
    String magic_school_id 
    SpellAttackType attack_type "❓"
    Ability save_ability "❓"
    SpellDcSuccess save_success "❓"
    String save_description "❓"
    String damage_type_id "❓"
    AreaOfEffectType area_of_effect_type "❓"
    Int area_of_effect_size_ft "❓"
    String description 
    String higher_level_desc 
    ContentSource source 
    String owner_id "❓"
    ContentVisibility visibility 
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "spell_scalings" {
    String id "🗝️"
    String spell_id 
    SpellScalingKind kind 
    Int level 
    String value 
    }
  

  "spell_classes" {
    String id "🗝️"
    String spell_id 
    String character_class_id 
    }
  

  "spell_subclasses" {
    String id "🗝️"
    String spell_id 
    String subclass_id 
    }
  

  "character_classes" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    Int hit_die 
    ContentSource source 
    String owner_id "❓"
    ContentVisibility visibility 
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "class_saving_throws" {
    String id "🗝️"
    String character_class_id 
    Ability ability 
    }
  

  "class_proficiency_grants" {
    String id "🗝️"
    String character_class_id 
    String proficiency_id 
    Boolean on_multiclass 
    }
  

  "class_starting_equipment_items" {
    String id "🗝️"
    String character_class_id 
    String item_id 
    Int quantity 
    }
  

  "multiclass_prerequisites" {
    String id "🗝️"
    String character_class_id 
    Ability ability 
    Int minimum_score 
    }
  

  "class_spellcastings" {
    String id "🗝️"
    String character_class_id 
    Int min_level 
    Ability spellcasting_ability 
    CasterKind caster_kind 
    SpellPreparationMode preparation_mode 
    Boolean ritual_casting 
    Boolean ritual_requires_prepared 
    Json infoBlocks "❓"
    }
  

  "subclasses" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String character_class_id 
    String subclass_flavor 
    String description 
    ContentSource source 
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "subclass_spells" {
    String id "🗝️"
    String subclass_id 
    String spell_id 
    }
  

  "subclass_spell_prerequisites" {
    String id "🗝️"
    String subclass_spell_id 
    SubclassSpellPrerequisiteKind kind 
    Int level "❓"
    String class_feature_id "❓"
    String target_srd_index "❓"
    }
  

  "class_levels" {
    String id "🗝️"
    String srd_index "❓"
    String character_class_id 
    Int level 
    Int prof_bonus 
    Int ability_score_bonuses 
    Json class_specific "❓"
    ContentSource source 
    }
  

  "class_level_spellcastings" {
    String id "🗝️"
    String class_level_id 
    Int cantrips_known "❓"
    Int spells_known "❓"
    }
  

  "class_level_spell_slots" {
    String id "🗝️"
    String class_level_spellcasting_id 
    Int slot_level 
    Int slots 
    }
  

  "subclass_levels" {
    String id "🗝️"
    String srd_index "❓"
    String subclass_id 
    Int level 
    Json subclass_specific "❓"
    ContentSource source 
    }
  

  "class_resource_definitions" {
    String id "🗝️"
    String srd_index "❓"
    String character_class_id "❓"
    ClassResourceValueKind value_kind 
    String label 
    Boolean supports_unlimited 
    Boolean consumable 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "class_features" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String character_class_id 
    String subclass_id "❓"
    Int level 
    FeatureGrantKind grant_kind 
    String description 
    String parent_feature_id "❓"
    String reference_url "❓"
    ContentSource source 
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "class_feature_armor_formulas" {
    String id "🗝️"
    String class_feature_id 
    Int base 
    Ability abilities 
    Boolean allows_shield 
    ContentSource source 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "feature_prerequisites" {
    String id "🗝️"
    String class_feature_id 
    FeaturePrerequisiteKind kind 
    Int level "❓"
    String target_feature_id "❓"
    String target_spell_id "❓"
    String target_url "❓"
    }
  

  "races" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    Int speed_ft 
    Size size 
    String size_description 
    String alignment_description 
    String age_description 
    String language_description 
    ContentSource source 
    String owner_id "❓"
    ContentVisibility visibility 
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "subraces" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String race_id 
    String description 
    ContentSource source 
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "racial_traits" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    String parent_trait_id "❓"
    ContentSource source 
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "race_trait_grants" {
    String id "🗝️"
    String race_id "❓"
    String subrace_id "❓"
    String racial_trait_id 
    Int sort_order 
    }
  

  "race_languages" {
    String id "🗝️"
    String race_id 
    String language_id 
    }
  

  "ability_bonus_grants" {
    String id "🗝️"
    String race_id "❓"
    String subrace_id "❓"
    Ability ability 
    Int bonus 
    }
  

  "racial_trait_proficiencies" {
    String id "🗝️"
    String racial_trait_id 
    String proficiency_id 
    }
  

  "breath_weapon_details" {
    String id "🗝️"
    String racial_trait_id 
    String name 
    String description 
    AreaOfEffectType area_of_effect_type 
    Int area_of_effect_size_ft 
    UsageInterval usage_interval 
    Int usage_times 
    Ability save_ability 
    SpellDcSuccess save_success 
    String damage_type_id 
    }
  

  "breath_weapon_damage_by_levels" {
    String id "🗝️"
    String breath_weapon_detail_id 
    Int character_level 
    String damage_dice 
    }
  

  "backgrounds" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    Int starting_gold_cp "❓"
    ContentSource source 
    String owner_id "❓"
    ContentVisibility visibility 
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "background_features" {
    String id "🗝️"
    String background_id 
    String name 
    String description 
    }
  

  "background_proficiencies" {
    String id "🗝️"
    String background_id 
    String proficiency_id 
    }
  

  "background_starting_equipment_items" {
    String id "🗝️"
    String background_id 
    String item_id 
    Int quantity 
    }
  

  "feats" {
    String id "🗝️"
    String srd_index "❓"
    String name 
    String description 
    ContentSource source 
    String owner_id "❓"
    ContentVisibility visibility 
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "feat_prerequisites" {
    String id "🗝️"
    String feat_id 
    Ability ability 
    Int minimum_score 
    }
  

  "translations" {
    String id "🗝️"
    TranslatableEntity entity_type 
    String entity_id 
    String locale 
    String name 
    String description 
    Json extra "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "characters" {
    String id "🗝️"
    String name 
    Int strength 
    Int dexterity 
    Int constitution 
    Int intelligence 
    Int wisdom 
    Int charisma 
    Int armor_class_override "❓"
    Int armor_class_bonus 
    Int current_hit_points 
    Int temporary_hit_points 
    Int death_save_successes 
    Int death_save_failures 
    Int experience_points 
    Boolean inspiration 
    Int copper_pieces 
    Int silver_pieces 
    Int electrum_pieces 
    Int gold_pieces 
    Int platinum_pieces 
    String personality_traits 
    String ideals 
    String bonds 
    String flaws 
    String appearance "❓"
    String backstory "❓"
    String allies_and_organizations "❓"
    String notes "❓"
    SheetVisibility sheet_visibility 
    String user_id 
    String race_id 
    String subrace_id "❓"
    String background_id 
    String alignment_id "❓"
    String campaign_id "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "character_class_levels" {
    String id "🗝️"
    String character_id 
    String character_class_id 
    Int level 
    String subclass_id "❓"
    Boolean is_primary 
    Int hit_points_rolled "❓"
    Int hit_dice_spent 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "character_proficiencies" {
    String id "🗝️"
    String character_id 
    String proficiency_id 
    ProficiencyOrigin origin 
    Boolean expertise 
    DateTime created_at 
    }
  

  "character_languages" {
    String id "🗝️"
    String character_id 
    String language_id 
    GrantOrigin origin 
    }
  

  "character_spells" {
    String id "🗝️"
    String character_id 
    String spell_id 
    GrantOrigin origin 
    String character_class_id "❓"
    String subclass_id "❓"
    Boolean prepared 
    Boolean always_prepared 
    Int usage_times "❓"
    UsageInterval usage_interval "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "character_features" {
    String id "🗝️"
    String character_id 
    String class_feature_id "❓"
    String racial_trait_id "❓"
    String background_feature_id "❓"
    String background_id "❓"
    String feat_id "❓"
    GrantOrigin origin 
    Int acquired_at_level "❓"
    Int usage_times "❓"
    UsageInterval usage_interval "❓"
    String notes "❓"
    DateTime created_at 
    }
  

  "inventory_items" {
    String id "🗝️"
    String character_id 
    String item_id 
    Int quantity 
    Boolean equipped 
    Boolean attuned 
    String custom_name "❓"
    String notes "❓"
    String container_id "❓"
    Int charges_remaining "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "character_conditions" {
    String id "🗝️"
    String character_id 
    String condition_id 
    Int level "❓"
    DateTime created_at 
    }
  

  "character_spell_slots" {
    String id "🗝️"
    String character_id 
    Int slot_level 
    Int expended 
    Boolean is_pact_magic 
    }
  

  "character_resource_usages" {
    String id "🗝️"
    String character_id 
    String resource_definition_id "❓"
    String racial_trait_id "❓"
    String class_feature_id "❓"
    String character_spell_id "❓"
    String inventory_item_id "❓"
    Int used 
    Int max_override "❓"
    UsageInterval resets_on "❓"
    DateTime updated_at 
    }
  

  "character_active_effects" {
    String id "🗝️"
    String character_id 
    String character_spell_id 
    Boolean requires_concentration 
    Int cast_at_slot_level "❓"
    DateTime started_at 
    DateTime expires_at "❓"
    }
  

  "character_ability_improvements" {
    String id "🗝️"
    String character_id 
    String character_class_id 
    Int at_class_level 
    AbilityImprovementKind kind 
    Ability ability "❓"
    Int amount "❓"
    String feat_id "❓"
    DateTime created_at 
    }
  

  "character_hit_point_modifiers" {
    String id "🗝️"
    String character_id 
    GrantOrigin origin 
    String racial_trait_id "❓"
    String feat_id "❓"
    Int flat_bonus 
    Int per_level_bonus 
    DateTime created_at 
    }
  

  "character_choice_selections" {
    String id "🗝️"
    String character_id 
    String choice_id 
    String choice_option_id 
    DateTime created_at 
    }
  

  "character_drafts" {
    String id "🗝️"
    CharacterDraftStep current_step 
    String name "❓"
    Int strength "❓"
    Int dexterity "❓"
    Int constitution "❓"
    Int intelligence "❓"
    Int wisdom "❓"
    Int charisma "❓"
    String user_id 
    String race_id "❓"
    String subrace_id "❓"
    String background_id "❓"
    String alignment_id "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "character_draft_class_levels" {
    String id "🗝️"
    String character_draft_id 
    String character_class_id 
    Int level 
    String subclass_id "❓"
    Boolean is_primary 
    }
  

  "character_draft_selections" {
    String id "🗝️"
    String character_draft_id 
    String choice_id 
    String choice_option_id 
    DateTime created_at 
    }
  

  "campaigns" {
    String id "🗝️"
    String name 
    String description "❓"
    String owner_id 
    String invite_code "❓"
    DateTime invite_code_expires_at "❓"
    Int invite_code_max_uses "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "campaign_members" {
    String id "🗝️"
    String campaign_id 
    String user_id 
    CampaignRole role 
    DateTime joined_at 
    DateTime left_at "❓"
    String joined_via_invite_code "❓"
    }
  

  "users" {
    String id "🗝️"
    String name 
    String email 
    DateTime premium_until "❓"
    DateTime deleted_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "user_credentials" {
    String id "🗝️"
    String user_id 
    String password_hash 
    DateTime credentials_invalidated_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  

  "payments" {
    String id "🗝️"
    String user_id "❓"
    String external_payment 
    PaymentStatus status 
    Int amount_minor_units 
    Currency currency 
    DateTime granted_from "❓"
    DateTime granted_until "❓"
    DateTime paid_at "❓"
    DateTime created_at 
    DateTime updated_at 
    }
  
    "ability_scores" |o--|| "Ability" : "enum:ability"
    "ability_scores" |o--|| "ContentSource" : "enum:source"
    "skills" |o--|| "Ability" : "enum:ability"
    "skills" |o--|| "ContentSource" : "enum:source"
    "damage_types" |o--|| "ContentSource" : "enum:source"
    "magic_schools" |o--|| "ContentSource" : "enum:source"
    "conditions" |o--|| "ContentSource" : "enum:source"
    "alignments" |o--|| "ContentSource" : "enum:source"
    "languages" |o--|| "LanguageRarity" : "enum:rarity"
    "languages" |o--|o "LanguageScript" : "enum:script"
    "languages" |o--|| "ContentSource" : "enum:source"
    "proficiencies" |o--|| "ProficiencyCategory" : "enum:category"
    "proficiencies" }o--|o items : "item"
    "proficiencies" }o--|o equipment_categories : "equipmentCategory"
    "proficiencies" }o--|o skills : "skill"
    "proficiencies" |o--|o "Ability" : "enum:saving_throw"
    "proficiencies" |o--|| "ContentSource" : "enum:source"
    "option_choices" |o--|| "ChoiceKind" : "enum:kind"
    "option_choices" |o--|| "OptionSetType" : "enum:option_set_type"
    "option_choices" }o--|o equipment_categories : "equipmentCategory"
    "option_choices" |o--|| "ChoiceAnchor" : "enum:anchor"
    "option_choices" }o--|o races : "race"
    "option_choices" }o--|o subraces : "subrace"
    "option_choices" }o--|o racial_traits : "racialTrait"
    "option_choices" }o--|o character_classes : "characterClass"
    "option_choices" }o--|o class_features : "classFeature"
    "option_choices" }o--|o backgrounds : "background"
    "option_choices" }o--|o feats : "feat"
    "option_choices" |o--|| "ContentSource" : "enum:source"
    "choice_options" }o--|| option_choices : "choice"
    "choice_options" |o--|| "ChoiceOptionType" : "enum:option_type"
    "choice_options" }o--|o option_choices : "nestedChoice"
    "choice_options" |o--|o choice_options : "parentOption"
    "choice_options" |o--|o "Ability" : "enum:ability"
    "choice_option_references" |o--|| choice_options : "choiceOption"
    "choice_option_references" |o--|| "ChoiceTargetType" : "enum:target_type"
    "choice_option_references" }o--|o items : "item"
    "choice_option_references" }o--|o equipment_categories : "equipmentCategory"
    "choice_option_references" }o--|o proficiencies : "proficiency"
    "choice_option_references" }o--|o skills : "skill"
    "choice_option_references" }o--|o languages : "language"
    "choice_option_references" }o--|o spells : "spell"
    "choice_option_references" }o--|o racial_traits : "racialTrait"
    "choice_option_references" }o--|o class_features : "classFeature"
    "choice_option_references" }o--|o subclasses : "subclass"
    "choice_option_references" |o--|o "Ability" : "enum:ability"
    "choice_option_alignments" }o--|| choice_options : "choiceOption"
    "choice_option_alignments" }o--|| alignments : "alignment"
    "equipment_categories" |o--|| "ContentSource" : "enum:source"
    "items" |o--|| "ItemKind" : "enum:item_kind"
    "items" |o--|o "ToolCategory" : "enum:tool_category"
    "items" |o--|o items : "basedOnItem"
    "items" |o--|| "ContentSource" : "enum:source"
    "items" }o--|o users : "owner"
    "items" |o--|| "ContentVisibility" : "enum:visibility"
    "items" }o--|o campaigns : "campaign"
    "weapon_details" |o--|| items : "item"
    "weapon_details" |o--|| "WeaponCategory" : "enum:weapon_category"
    "weapon_details" |o--|| "WeaponRange" : "enum:weapon_range"
    "weapon_details" }o--|o damage_types : "damageType"
    "weapon_details" }o--|o damage_types : "twoHandedDamageType"
    "armor_details" |o--|| items : "item"
    "armor_details" |o--|| "ArmorCategory" : "enum:armor_category"
    "vehicle_details" |o--|| items : "item"
    "vehicle_details" |o--|| "VehicleCategory" : "enum:vehicle_category"
    "vehicle_details" |o--|o "SpeedUnit" : "enum:speed_unit"
    "magic_item_details" |o--|| items : "item"
    "magic_item_details" |o--|| "MagicItemRarity" : "enum:rarity"
    "item_categories" }o--|| items : "item"
    "item_categories" }o--|| equipment_categories : "equipmentCategory"
    "weapon_properties" |o--|| "ContentSource" : "enum:source"
    "item_weapon_properties" }o--|| items : "item"
    "item_weapon_properties" }o--|| weapon_properties : "weaponProperty"
    "item_pack_contents" }o--|| items : "packItem"
    "item_pack_contents" }o--|| items : "item"
    "spells" }o--|| magic_schools : "magicSchool"
    "spells" |o--|o "SpellAttackType" : "enum:attack_type"
    "spells" |o--|o "Ability" : "enum:save_ability"
    "spells" |o--|o "SpellDcSuccess" : "enum:save_success"
    "spells" }o--|o damage_types : "damageType"
    "spells" |o--|o "AreaOfEffectType" : "enum:area_of_effect_type"
    "spells" |o--|| "ContentSource" : "enum:source"
    "spells" }o--|o users : "owner"
    "spells" |o--|| "ContentVisibility" : "enum:visibility"
    "spells" }o--|o campaigns : "campaign"
    "spell_scalings" }o--|| spells : "spell"
    "spell_scalings" |o--|| "SpellScalingKind" : "enum:kind"
    "spell_classes" }o--|| spells : "spell"
    "spell_classes" }o--|| character_classes : "characterClass"
    "spell_subclasses" }o--|| spells : "spell"
    "spell_subclasses" }o--|| subclasses : "subclass"
    "character_classes" |o--|| "ContentSource" : "enum:source"
    "character_classes" }o--|o users : "owner"
    "character_classes" |o--|| "ContentVisibility" : "enum:visibility"
    "character_classes" }o--|o campaigns : "campaign"
    "class_saving_throws" }o--|| character_classes : "characterClass"
    "class_saving_throws" |o--|| "Ability" : "enum:ability"
    "class_proficiency_grants" }o--|| character_classes : "characterClass"
    "class_proficiency_grants" }o--|| proficiencies : "proficiency"
    "class_starting_equipment_items" }o--|| character_classes : "characterClass"
    "class_starting_equipment_items" }o--|| items : "item"
    "multiclass_prerequisites" }o--|| character_classes : "characterClass"
    "multiclass_prerequisites" |o--|| "Ability" : "enum:ability"
    "class_spellcastings" |o--|| character_classes : "characterClass"
    "class_spellcastings" |o--|| "Ability" : "enum:spellcasting_ability"
    "class_spellcastings" |o--|| "CasterKind" : "enum:caster_kind"
    "class_spellcastings" |o--|| "SpellPreparationMode" : "enum:preparation_mode"
    "subclasses" }o--|| character_classes : "characterClass"
    "subclasses" |o--|| "ContentSource" : "enum:source"
    "subclass_spells" }o--|| subclasses : "subclass"
    "subclass_spells" }o--|| spells : "spell"
    "subclass_spell_prerequisites" }o--|| subclass_spells : "subclassSpell"
    "subclass_spell_prerequisites" |o--|| "SubclassSpellPrerequisiteKind" : "enum:kind"
    "subclass_spell_prerequisites" }o--|o class_features : "classFeature"
    "class_levels" }o--|| character_classes : "characterClass"
    "class_levels" |o--|| "ContentSource" : "enum:source"
    "class_level_spellcastings" |o--|| class_levels : "classLevel"
    "class_level_spell_slots" }o--|| class_level_spellcastings : "classLevelSpellcasting"
    "subclass_levels" }o--|| subclasses : "subclass"
    "subclass_levels" |o--|| "ContentSource" : "enum:source"
    "class_resource_definitions" }o--|o character_classes : "characterClass"
    "class_resource_definitions" |o--|| "ClassResourceValueKind" : "enum:value_kind"
    "class_resource_definitions" |o--|| "ContentSource" : "enum:source"
    "class_features" }o--|| character_classes : "characterClass"
    "class_features" }o--|o subclasses : "subclass"
    "class_features" |o--|| "FeatureGrantKind" : "enum:grant_kind"
    "class_features" |o--|o class_features : "parentFeature"
    "class_features" |o--|| "ContentSource" : "enum:source"
    "class_feature_armor_formulas" |o--|| class_features : "classFeature"
    "class_feature_armor_formulas" |o--}o "Ability" : "enum:abilities"
    "class_feature_armor_formulas" |o--|| "ContentSource" : "enum:source"
    "feature_prerequisites" }o--|| class_features : "classFeature"
    "feature_prerequisites" |o--|| "FeaturePrerequisiteKind" : "enum:kind"
    "feature_prerequisites" }o--|o class_features : "targetFeature"
    "feature_prerequisites" }o--|o spells : "targetSpell"
    "races" |o--|| "Size" : "enum:size"
    "races" |o--|| "ContentSource" : "enum:source"
    "races" }o--|o users : "owner"
    "races" |o--|| "ContentVisibility" : "enum:visibility"
    "races" }o--|o campaigns : "campaign"
    "subraces" }o--|| races : "race"
    "subraces" |o--|| "ContentSource" : "enum:source"
    "racial_traits" |o--|o racial_traits : "parentTrait"
    "racial_traits" |o--|| "ContentSource" : "enum:source"
    "race_trait_grants" }o--|o races : "race"
    "race_trait_grants" }o--|o subraces : "subrace"
    "race_trait_grants" }o--|| racial_traits : "racialTrait"
    "race_languages" }o--|| races : "race"
    "race_languages" }o--|| languages : "language"
    "ability_bonus_grants" }o--|o races : "race"
    "ability_bonus_grants" }o--|o subraces : "subrace"
    "ability_bonus_grants" |o--|| "Ability" : "enum:ability"
    "racial_trait_proficiencies" }o--|| racial_traits : "racialTrait"
    "racial_trait_proficiencies" }o--|| proficiencies : "proficiency"
    "breath_weapon_details" |o--|| racial_traits : "racialTrait"
    "breath_weapon_details" |o--|| "AreaOfEffectType" : "enum:area_of_effect_type"
    "breath_weapon_details" |o--|| "UsageInterval" : "enum:usage_interval"
    "breath_weapon_details" |o--|| "Ability" : "enum:save_ability"
    "breath_weapon_details" |o--|| "SpellDcSuccess" : "enum:save_success"
    "breath_weapon_details" }o--|| damage_types : "damageType"
    "breath_weapon_damage_by_levels" }o--|| breath_weapon_details : "breathWeaponDetail"
    "backgrounds" |o--|| "ContentSource" : "enum:source"
    "backgrounds" }o--|o users : "owner"
    "backgrounds" |o--|| "ContentVisibility" : "enum:visibility"
    "backgrounds" }o--|o campaigns : "campaign"
    "background_features" |o--|| backgrounds : "background"
    "background_proficiencies" }o--|| backgrounds : "background"
    "background_proficiencies" }o--|| proficiencies : "proficiency"
    "background_starting_equipment_items" }o--|| backgrounds : "background"
    "background_starting_equipment_items" }o--|| items : "item"
    "feats" |o--|| "ContentSource" : "enum:source"
    "feats" }o--|o users : "owner"
    "feats" |o--|| "ContentVisibility" : "enum:visibility"
    "feats" }o--|o campaigns : "campaign"
    "feat_prerequisites" }o--|| feats : "feat"
    "feat_prerequisites" |o--|| "Ability" : "enum:ability"
    "translations" |o--|| "TranslatableEntity" : "enum:entity_type"
    "characters" |o--|| "SheetVisibility" : "enum:sheet_visibility"
    "characters" }o--|| users : "user"
    "characters" }o--|| races : "race"
    "characters" }o--|o subraces : "subrace"
    "characters" }o--|| backgrounds : "background"
    "characters" }o--|o alignments : "alignment"
    "characters" }o--|o campaigns : "campaign"
    "characters" }o--|o campaign_members : "membership"
    "character_class_levels" }o--|| characters : "character"
    "character_class_levels" }o--|| character_classes : "characterClass"
    "character_class_levels" }o--|o subclasses : "subclass"
    "character_proficiencies" }o--|| characters : "character"
    "character_proficiencies" }o--|| proficiencies : "proficiency"
    "character_proficiencies" |o--|| "ProficiencyOrigin" : "enum:origin"
    "character_languages" }o--|| characters : "character"
    "character_languages" }o--|| languages : "language"
    "character_languages" |o--|| "GrantOrigin" : "enum:origin"
    "character_spells" }o--|| characters : "character"
    "character_spells" }o--|| spells : "spell"
    "character_spells" |o--|| "GrantOrigin" : "enum:origin"
    "character_spells" }o--|o character_classes : "characterClass"
    "character_spells" }o--|o subclasses : "subclass"
    "character_spells" |o--|o "UsageInterval" : "enum:usage_interval"
    "character_features" }o--|| characters : "character"
    "character_features" }o--|o class_features : "classFeature"
    "character_features" }o--|o racial_traits : "racialTrait"
    "character_features" }o--|o background_features : "backgroundFeature"
    "character_features" }o--|o backgrounds : "background"
    "character_features" }o--|o feats : "feat"
    "character_features" |o--|| "GrantOrigin" : "enum:origin"
    "character_features" |o--|o "UsageInterval" : "enum:usage_interval"
    "inventory_items" }o--|| characters : "character"
    "inventory_items" }o--|| items : "item"
    "inventory_items" |o--|o inventory_items : "container"
    "character_conditions" }o--|| characters : "character"
    "character_conditions" }o--|| conditions : "condition"
    "character_spell_slots" }o--|| characters : "character"
    "character_resource_usages" }o--|| characters : "character"
    "character_resource_usages" }o--|o class_resource_definitions : "resourceDefinition"
    "character_resource_usages" }o--|o racial_traits : "racialTrait"
    "character_resource_usages" }o--|o class_features : "classFeature"
    "character_resource_usages" }o--|o character_spells : "characterSpell"
    "character_resource_usages" }o--|o inventory_items : "inventoryItem"
    "character_resource_usages" |o--|o "UsageInterval" : "enum:resets_on"
    "character_resource_usages" }o--|o character_features : "characterFeature"
    "character_active_effects" }o--|| characters : "character"
    "character_active_effects" }o--|| character_spells : "characterSpell"
    "character_ability_improvements" }o--|| characters : "character"
    "character_ability_improvements" }o--|| character_classes : "characterClass"
    "character_ability_improvements" |o--|| "AbilityImprovementKind" : "enum:kind"
    "character_ability_improvements" |o--|o "Ability" : "enum:ability"
    "character_ability_improvements" }o--|o feats : "feat"
    "character_hit_point_modifiers" }o--|| characters : "character"
    "character_hit_point_modifiers" |o--|| "GrantOrigin" : "enum:origin"
    "character_hit_point_modifiers" }o--|o racial_traits : "racialTrait"
    "character_hit_point_modifiers" }o--|o feats : "feat"
    "character_choice_selections" }o--|| characters : "character"
    "character_choice_selections" }o--|| option_choices : "choice"
    "character_choice_selections" }o--|| choice_options : "choiceOption"
    "character_drafts" |o--|| "CharacterDraftStep" : "enum:current_step"
    "character_drafts" }o--|| users : "user"
    "character_drafts" }o--|o races : "race"
    "character_drafts" }o--|o subraces : "subrace"
    "character_drafts" }o--|o backgrounds : "background"
    "character_drafts" }o--|o alignments : "alignment"
    "character_draft_class_levels" }o--|| character_drafts : "characterDraft"
    "character_draft_class_levels" }o--|| character_classes : "characterClass"
    "character_draft_class_levels" }o--|o subclasses : "subclass"
    "character_draft_selections" }o--|| character_drafts : "characterDraft"
    "character_draft_selections" }o--|| option_choices : "choice"
    "character_draft_selections" }o--|| choice_options : "choiceOption"
    "campaigns" }o--|| users : "owner"
    "campaign_members" }o--|| campaigns : "campaign"
    "campaign_members" }o--|| users : "user"
    "campaign_members" |o--|| "CampaignRole" : "enum:role"
    "user_credentials" |o--|| users : "user"
    "payments" }o--|o users : "user"
    "payments" |o--|| "PaymentStatus" : "enum:status"
    "payments" |o--|| "Currency" : "enum:currency"
```
