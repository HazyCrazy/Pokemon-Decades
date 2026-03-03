module GameData
  class Species
    class << self
      alias _following_pkmn_check_graphic_file check_graphic_file unless method_defined?(:_following_pkmn_check_graphic_file)
    end

    def self.check_graphic_file(path, species, form = 0, gender = 0, shiny = false, shadow = false, subfolder = "")
      try_subfolder = sprintf("%s/", subfolder)
      try_species = species
      try_form    = (form > 0) ? sprintf("_%d", form) : ""
      try_gender  = (gender == 1) ? "_female" : ""
      try_shadow  = (shadow) ? "_shadow" : ""
      factors = []
      if shiny == 2
        factors.push([4, sprintf("%s super shiny/", subfolder), try_subfolder])
      elsif shiny
        factors.push([4, sprintf("%s shiny/", subfolder), try_subfolder])
      end
      factors.push([3, try_shadow, ""]) if shadow
      factors.push([2, try_gender, ""]) if gender == 1
      factors.push([1, try_form, ""]) if form > 0
      factors.push([0, try_species, "000"])
      # Go through each combination of parameters in turn to find an existing sprite
      (2**factors.length).times do |i|
        # Set try_ parameters for this combination
        factors.each_with_index do |factor, index|
          value = ((i / (2**index)).even?) ? factor[1] : factor[2]
          case factor[0]
          when 0 then try_species   = value
          when 1 then try_form      = value
          when 2 then try_gender    = value
          when 3 then try_shadow    = value
          when 4 then try_subfolder = value   # Shininess
          end
        end
        # Look for a graphic matching this combination's parameters
        try_species_text = try_species
        ret = pbResolveBitmap(sprintf("%s%s%s%s%s%s", path, try_subfolder,
                                      try_species_text, try_form, try_gender, try_shadow))
        return ret if ret
      end
      return nil
    end
  end
end
