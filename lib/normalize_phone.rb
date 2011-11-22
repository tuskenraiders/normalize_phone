require "normalize_phone/version"
require 'active_support/concern'
require 'active_support/core_ext/module/attribute_accessors'

# Länder, bei denen eine automatische Landesvorwahlerkennung stattfindet
# Deutschland         49
# Albanien            355
# Belgien             32
# Bosnien-Herzegowina 387
# Bulgarien           359
# Dänemark            45
# Estland             372
# Finnland            358
# Frankreich          33
# Griechenland        30
# Großbritanien       44
# Irland              353
# Italien             39
# Kroatien            385
# Lettland            371
# Lichtenstein        376
# Litauen             370
# Luxemburg           352
# Mazedonien          389
# Moldawien           373
# Niederlande         31
# Norwegen            47
# Österreich          43
# Polen               48
# Portugal            351
# Rumänien            40
# Russland            7
# Schweden            46
# Schweiz             41
# Serbien/Montenegro  381
# Slowakei            421
# Slowenien           386
# Spanien             34
# Tschechien          420
# Türkei              90
# Ukraine             380
# Ungarn              36
# Weißrussland        375
# Zypern              357

module NormalizePhone
  extend ActiveSupport::Concern
  USER_INPUT_REGEXP = /\A(?:(?:(?:\+|\+\+|00)([1-9]\d{0,3}) (?:0)?)|(?:0))(?:\s)?([1-9][0-9 ]{2,})\Z/
  DATABASE_REGEXP   = /\A\+\d{1,4} [1-9]\d{2,}\Z/
  mattr_accessor :default_country_code
  GERMANY = 49
  
  # Normalizes a phone number
  # Returns normalized number if the given number passes the internal validation, the original number otherwise
  def normalize(number)
    number or return
    country_code_regex = /\A(?:\+|\+\+|00)(?: )?(7|30|31|32|33|34|36|39|40|41|43|44|45|46|47|48|49|90|351|352|353|355|357|358|359|370|371|372|373|375|376|380|381|385|386|387|389|420|421)/
    stripped_number = number =~ country_code_regex ? number.sub(country_code_regex, "+#{$1} ") : number
    stripped_number = stripped_number.gsub(/[\(\)\-\/\.]/, " ").gsub(/\s{2,}/, " ").strip
    if stripped_number.match(USER_INPUT_REGEXP)
      "+#{$1 || NormalizePhone.default_country_code || NormalizePhone::GERMANY} #{$2.gsub(" ", "")}"
    else # ungültig => lasse unverändert
      number
    end
  end
  module_function :normalize

  
  module ClassMethods
    # Defines active record attributes to be normalized before value assignment
    def normalize_phone_attributes(*attrs)
      attrs.each do |attr|
        define_method "#{attr}=" do |number|
          write_attribute(attr, NormalizePhone.normalize(number))
        end
      end
    end
  end
end
