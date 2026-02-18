#===============================================================================
# Pokémon Vault – Core Storage System
#===============================================================================
# External, cross-save, cross-game Pokémon storage.
#===============================================================================

module PokemonVault
  VAULT_FOLDER_NAME = "Pokemon Vault"
  VAULT_FILE        = "vault.dat"
  MAX_BOXES         = 400
  BOX_SIZE          = 30

  module_function

  #---------------------------------------------------------------------------
  # Vault Data
  #---------------------------------------------------------------------------

  def vault_directory
    parent = File.dirname(System.data_directory)
    dir = File.join(parent, VAULT_FOLDER_NAME)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    return dir
  end

  def vault_path
    File.join(vault_directory, VAULT_FILE)
  end

  def empty_vault
    Array.new(MAX_BOXES) { Array.new(BOX_SIZE) }
  end

  def valid_vault?(vault)
    return false if !vault.is_a?(Array)
    return false if vault.length != MAX_BOXES
    vault.all? { |box| box.is_a?(Array) && box.length == BOX_SIZE }
  end

  def load_vault
    path = vault_path
    return empty_vault if !File.exist?(path)
    data = Marshal.load(File.binread(path))
    return valid_vault?(data) ? data : empty_vault
  rescue
    return empty_vault
  end

  def save_vault(vault)
    File.binwrite(vault_path, Marshal.dump(vault))
  end

  #---------------------------------------------------------------------------
  # Eligibility Rules
  #---------------------------------------------------------------------------

  def storable_pokemon?(pkmn)
    return false if !pkmn
    return false if pkmn.egg?

    species = pkmn.species_data
    return false if species.has_flag?("NotTradeable")
    return false if species.has_flag?("NotStorable")

    true
  end

  #---------------------------------------------------------------------------
  # Vault Operations
  #---------------------------------------------------------------------------

  def first_empty_slot(vault)
    vault.each_with_index do |box, b|
      box.each_with_index do |slot, s|
        return [b, s] if slot.nil?
      end
    end
    nil
  end

  def add_pokemon(pkmn)
    return false if !storable_pokemon?(pkmn)
    vault = load_vault
    pos = first_empty_slot(vault)
    return false if !pos

    b, s = pos
    vault[b][s] = pkmn
    save_vault(vault)
    true
  end

  def remove_pokemon(box, slot)
    vault = load_vault
    return nil if !vault.dig(box, slot)

    pkmn = vault[box][slot]
    vault[box][slot] = nil
    save_vault(vault)
    pkmn
  end

  #---------------------------------------------------------------------------
  # Remove/Add From PC
  #---------------------------------------------------------------------------

  def remove_from_pc(box, slot)
    pkmn = $PokemonStorage[box, slot]
    return nil if !storable_pokemon?(pkmn)

    $PokemonStorage[box, slot] = nil
    pkmn
  end

  def add_to_pc(pkmn)
    return false if !pkmn
    return !$PokemonStorage.pbStoreCaught(pkmn).nil?
  end
end
