#===============================================================================
# Advanced AI System - Settings & Configuration
# Version: 2.0
#===============================================================================

module AdvancedAI
  # ============================================================================
  # CORE SETTINGS
  # ============================================================================
  
  # Enable/Disable the entire system
  ENABLED = true
  
  # Auto-activate with Challenge Modes plugin (if installed)
  ACTIVATE_WITH_CHALLENGE_MODES = true
  
  # Minimum skill level for auto-activation
  MIN_SKILL_FOR_AUTO_ACTIVATION = 70
  
  # Debug mode - detailed logging in console
  DEBUG_MODE = false
  
  # Debug switch intelligence specifically (verbose logging)
  DEBUG_SWITCH_INTELLIGENCE = false
  
  # Show move explanations in battle text (e.g., "Thunder Wave (Paralyze fast threat)")
  SHOW_MOVE_EXPLANATIONS = false
  
  # Logging options
  LOG_TO_CONSOLE = false   # Print logs to console window
  LOG_TO_FILE = false     # Write logs to file (Logs/ai_log.txt)
  
  # ============================================================================
  # WILD POKEMON AI SETTINGS
  # ============================================================================
  
  # Enable smart AI for wild Pokemon (uses move scoring instead of random selection)
  ENABLE_WILD_POKEMON_AI = false
  
  # Skill level for wild Pokemon when AI is enabled (0-100)
  # 0     = Random moves (vanilla behavior)
  # 50-69 = Core AI features
  # 70-84 = Advanced features  
  # 85-99 = Expert AI (items, patterns, personalities)
  # 100   = Master AI (includes Terastallization)
  WILD_POKEMON_SKILL_LEVEL = 100
  
  # ============================================================================
  # SKILL LEVEL THRESHOLDS
  # ============================================================================
  
  # Defines which AI features are enabled at each skill level
  SKILL_THRESHOLDS = {
    :core              => 50,   # Core AI (Move Scoring, Memory, Threats)
    :switch_intelligence => 50, # Switch Intelligence (Type matchup analysis)
    :setup             => 55,   # Setup Recognition
    :endgame           => 60,   # Endgame Scenarios (1v1, 2v2)
    :personalities     => 65,   # Battle Personalities
    :items             => 85,   # Item Intelligence
    :prediction        => 85,   # Prediction System
    :mega_evolution    => 90,   # Mega Evolution Intelligence
    :z_moves           => 90,   # Z-Move Intelligence (DBK_004)
    :dynamax           => 95,   # Dynamax Intelligence (DBK_005)
    :terastallization  => 100   # Terastallization (DBK_006)
  }
  
  # Switch decision thresholds by AI mode (simplified to 3 tiers)
  # Higher threshold = Less likely to switch (Must be in more danger)
  SWITCH_THRESHOLDS = {
    :beginner => 65,  # Skill 0-60: Stays in until very dangerous
    :mid      => 55,  # Skill 61-85: Balanced switching
    :pro      => 45,  # Skill 86+: Aggressive but stable switching
    :extreme  => 35   # Skill 100 + manual override: Near-perfect play
  }
  
  # === ENHANCED DIFFICULTY FEATURES BY TIER ===
  # Defines behavioral differences across difficulty levels
  TIER_FEATURES = {
    :beginner => {
      :switch_prediction   => false,   # No switch prediction
      :setup_detection     => false,   # Doesn't detect setup threats
      :hazard_awareness    => false,   # Ignores entry hazards
      :pivot_preference    => false,   # No pivot move priority
      :recovery_timing     => false,   # Basic recovery (when low HP)
      :status_value        => 0.5,     # 50% status move value
      :prediction_depth    => 0,       # No prediction
      :learn_patterns      => false    # No learning
    },
    :mid => {
      :switch_prediction   => true,    # Basic switch prediction
      :setup_detection     => true,    # Detects obvious setup (2+ boosts)
      :hazard_awareness    => true,    # Considers hazards
      :pivot_preference    => true,    # Prefers pivots when available
      :recovery_timing     => true,    # Smart recovery timing
      :status_value        => 1.0,     # Full status move value
      :prediction_depth    => 1,       # 1-turn prediction
      :learn_patterns      => false    # No learning yet
    },
    :pro => {
      :switch_prediction   => true,    # Advanced switch prediction
      :setup_detection     => true,    # Detects all setup threats
      :hazard_awareness    => true,    # Full hazard calculation
      :pivot_preference    => true,    # Optimal pivot usage
      :recovery_timing     => true,    # Perfect recovery timing
      :status_value        => 1.2,     # 120% status move value
      :prediction_depth    => 2,       # 2-turn prediction
      :learn_patterns      => true     # Basic pattern learning
    },
    :extreme => {
      :switch_prediction   => true,    # Perfect switch prediction
      :setup_detection     => true,    # Instant setup threat response
      :hazard_awareness    => true,    # Complete hazard mastery
      :pivot_preference    => true,    # Frame-perfect pivots
      :recovery_timing     => true,    # Optimal recovery (accounts for all factors)
      :status_value        => 1.5,     # 150% status move value
      :prediction_depth    => 3,       # 3-turn prediction
      :learn_patterns      => true     # Advanced pattern recognition
    }
  }
  
  # ============================================================================
  # ADVANCED FLAGS (Bit Flags for Fine-Tuning)
  # ============================================================================
  
  # Use bit flags for granular control
  # Example: 0b00000001 = Enable switch-ins prediction
  #          0b00000010 = Enable setup chain detection
  #          0b00000100 = Enable hazard calculations
  
  ADVANCED_FLAGS = {
    :switch_prediction    => 0b00000001,  # Predict opponent switches
    :setup_chains         => 0b00000010,  # Detect setup chains (Baton Pass)
    :hazard_calc          => 0b00000100,  # Calculate hazard damage
    :weather_abuse        => 0b00001000,  # Abuse weather conditions
    :terrain_abuse        => 0b00010000,  # Abuse terrain conditions
    :ko_prediction        => 0b00100000,  # Predict KO scenarios
    :revenge_kill         => 0b01000000,  # Prevent revenge kills
    :momentum_control     => 0b10000000   # Control battle momentum
  }
  
  # Default flags (all enabled for skill 100+)
  DEFAULT_FLAGS = 0b11111111
  
  # ============================================================================
  # PERSONALITY SETTINGS
  # ============================================================================
  
  # Auto-detect personality from team composition
  AUTO_DETECT_PERSONALITY = true
  
  # Personality modifiers (applied to move scores)
  PERSONALITY_MODIFIERS = {
    :aggressive => {
      :setup_moves       => 40,
      :powerful_moves    => 30,
      :risky_moves       => 25,
      :recoil_moves      => 15,
      :defensive_moves   => -30
    },
    :defensive => {
      :hazards           => 50,
      :screens           => 45,
      :recovery          => 40,
      :protect           => 35,
      :status_moves      => 30,
      :toxic_stall       => 20
    },
    :balanced => {
      :safe_setup        => 20,
      :recovery_low_hp   => 15,
      :finish_weak       => 10,
      :risky_moves       => -5
    },
    :hyper_offensive => {
      :damage_moves      => 60,
      :priority_moves    => 40,
      :multi_target      => 35,
      :super_effective   => 30,
      :status_moves      => -50,
      :switching         => -60
    }
  }
  
  # ============================================================================
  # AI BEHAVIOR SETTINGS
  # ============================================================================
  
  # If true, the AI will respect the "ReserveLastPokemon" flag on trainers
  # preventing their ace (last Pokemon) from being switched in early
  RESPECT_RESERVE_LAST_POKEMON = true
  
  # If true, the AI enforces Sleep Clause (won't put a second Pokemon to sleep)
  # Set to false to allow the AI to use sleep moves freely
  ENFORCE_SLEEP_CLAUSE = true
  
  # ============================================================================
  # COMPATIBILITY SETTINGS
  # ============================================================================
  
  # DBK Plugin Integration
  DBK_PLUGINS = {
    :mega_evolution   => true,  # Core Essentials (Enhanced)
    :dynamax          => true,  # DBK_005 - Dynamax
    :terastallization => true,  # DBK_006 - Terastallization
    :z_moves          => true,  # DBK_004 - Z-Power
    :raid_battles     => true,  # DBK_003 - Raid Battles
    :sos_battles      => true   # DBK_002 - SOS Battles
  }
  
  # Generation 9 Pack compatibility
  GEN9_PACK_COMPAT = true
  
  # ============================================================================
  # HELPER METHODS
  # ============================================================================
  
  # Logging utility
  def self.log(message, source = "AAI")
    return unless DEBUG_MODE || LOG_TO_CONSOLE || LOG_TO_FILE
    
    # Escape % characters to prevent printf formatting issues
    safe_message = message.to_s.gsub('%', '%%')
    formatted = "[#{source}] #{safe_message}"
    
    # Console output
    if DEBUG_MODE || LOG_TO_CONSOLE
      echoln formatted
    end
    
    # File output
    if LOG_TO_FILE
      begin
        Dir.mkdir("Logs") unless Dir.exist?("Logs")
        File.open("Logs/ai_log.txt", "a") do |f|
          f.puts "[#{Time.now.strftime("%H:%M:%S")}] #{formatted}"
        end
      rescue SystemCallError, IOError
        # Silent fail if file writing fails
      end
    end
  end
  
  # Check if Advanced AI is active
  def self.active?
    return false unless ENABLED
    return true if DEBUG_MODE  # Auto-activate in debug mode
    return true if defined?(Settings::CHALLENGE_MODE) && Settings::CHALLENGE_MODE && ACTIVATE_WITH_CHALLENGE_MODES
    return @manually_activated || false
  end
  
  # Manually activate/deactivate
  def self.activate!
    @manually_activated = true
  end
  
  def self.deactivate!
    @manually_activated = false
  end
  
  # Check if skill level qualifies for Advanced AI
  # NOTE: This checks if ANY Advanced AI features are available (core threshold: 50)
  # MIN_SKILL_FOR_AUTO_ACTIVATION (70) is only for automatic activation
  def self.qualifies_for_advanced_ai?(skill_level)
    return false unless ENABLED  # System must be enabled
    return skill_level >= SKILL_THRESHOLDS[:core]  # Need at least core features (50+)
  end
  
  # Game Variable ID that controls the AI Mode globally
  # 0 = Disabled (Use Skill Level logic)
  # 1 = Force Beginner Mode
  # 2 = Force Mid Mode
  # 3 = Force Pro Mode
  AI_MODE_VARIABLE = 100
  
  # Get AI mode based on skill level (simplified to 3 tiers)
  def self.get_ai_tier(skill_level)
    # Check global variable override
    if defined?($game_variables)
      override = $game_variables[AI_MODE_VARIABLE]
      return :beginner if override == 1
      return :mid      if override == 2
      return :pro      if override == 3
      return :extreme  if override == 4  # New: Extreme difficulty
    end
    
    # Fallback to skill-based logic
    return :beginner if skill_level <= 60
    return :mid if skill_level <= 85
    return :pro if skill_level <= 99
    return :extreme  # Skill 100 = Extreme mode
  end
  
  # Get tier feature value
  def self.tier_feature(skill_level, feature)
    tier = get_ai_tier(skill_level)
    return TIER_FEATURES.dig(tier, feature)
  end
  
  # Check if feature is enabled for skill level
  # NOTE: This checks if a specific feature is enabled based on skill threshold
  # Does NOT require active? (that's only for global system activation)
  def self.feature_enabled?(feature, skill_level)
    return false unless ENABLED  # System must be globally enabled
    return false unless SKILL_THRESHOLDS[feature]  # Feature must exist
    return skill_level >= SKILL_THRESHOLDS[feature]  # Check skill threshold
  end
  
  # Get setting value (with fallback)
  def self.get_setting(key, default = 0)
    return ADVANCED_FLAGS[key] || default
  end
  
  # Check if DBK plugin is enabled
  def self.dbk_enabled?(plugin)
    return false unless DBK_PLUGINS[plugin]
    
    # 1. Try PluginManager check (most reliable)
    if defined?(PluginManager) && PluginManager.respond_to?(:installed?)
      plugin_id = case plugin
        when :dynamax           then "[DBK] Dynamax"
        when :terastallization  then "[DBK] Terastallization"
        when :z_moves           then "[DBK] Z-Power"
        when :raid_battles      then "[DBK] Raid Battles"
        when :sos_battles       then "[DBK] SOS Battles"
        else nil
      end
      return true if plugin_id && PluginManager.installed?(plugin_id)
    end
    
    # 2. Fallback to method/constant checks
    case plugin
    when :mega_evolution
      return true # Built-in to Essentials, always available if item held
    when :dynamax
      # Check if Dynamax methods exist (more reliable than constants)
      return defined?(Battle) && Battle.instance_methods.include?(:pbCanDynamax?)
    when :terastallization
      # Check if Terastallization methods exist
      return defined?(Battle) && Battle.instance_methods.include?(:pbCanTerastallize?)
    when :z_moves
      return defined?(Battle) && Battle.instance_methods.include?(:pbCanZMove?)
    when :raid_battles
      return defined?(Battle) && Battle.instance_methods.include?(:pbRaidBattle?)
    when :sos_battles
      return defined?(Battle) && Battle.instance_methods.include?(:pbSOSBattle?)
    else
      return false
    end
  end
end

#===============================================================================
# Battle Integration
#===============================================================================

class Battle
  attr_accessor :advanced_ai_active
  attr_accessor :trainer_personalities
  
  alias aai_initialize initialize
  def initialize(*args)
    aai_initialize(*args)
    @advanced_ai_active = false
    @trainer_personalities = {}
  end
  
  # Check if trainer uses Advanced AI
  def uses_advanced_ai?(trainer_index)
    return false unless AdvancedAI.active?
    return false unless trainer_index
    trainer = pbGetOwnerFromBattlerIndex(trainer_index)
    return false unless trainer
    skill = trainer.skill_level || 50
    return AdvancedAI.qualifies_for_advanced_ai?(skill)
  end
  
  # Get/Set trainer personality
  def get_trainer_personality(trainer_index)
    @trainer_personalities[trainer_index] ||= detect_personality(trainer_index)
  end
  
  def set_trainer_personality(trainer_index, personality)
    @trainer_personalities[trainer_index] = personality
    AdvancedAI.log("Trainer #{trainer_index} personality set to #{personality}", "Personality")
  end
  
  private
  
  def detect_personality(trainer_index)
    return :balanced unless AdvancedAI::AUTO_DETECT_PERSONALITY
    # Will be implemented in Battle_Personalities.rb
    return :balanced
  end
end

#===============================================================================
# Skill Level Enhancement
#===============================================================================

class Battle::Battler
  # Enhanced skill level with AI tier
  def ai_skill_level
    return 0 unless @battle.opposes?(@index)
    trainer = @battle.pbGetOwnerFromBattlerIndex(@index)
    return 50 unless trainer
    return trainer.skill_level || 50
  end
  
  def ai_tier
    return AdvancedAI.get_ai_tier(ai_skill_level)
  end
end

#===============================================================================
# Challenge Mode Integration (Optional)
#===============================================================================

if defined?(Settings::CHALLENGE_MODE)
  EventHandlers.add(:on_start_battle, :advanced_ai_challenge_mode,
    proc { |battle|
      if Settings::CHALLENGE_MODE && AdvancedAI::ACTIVATE_WITH_CHALLENGE_MODES
        battle.advanced_ai_active = true
        AdvancedAI.log("Advanced AI activated via Challenge Mode", "Core")
      end
    }
  )
end
