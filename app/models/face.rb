# frozen_string_literal: true

require 'yaml'

require_relative 'twemoji/twemoji'

# Defines an emoji face
class Face
  # Retrieves all faces
  def self.all(twemoji_version)
    twemoji_version = Twemoji.validate_version(twemoji_version)
    yml_file = "app/models/twemoji/#{twemoji_version}/face.yml"
    YAML.safe_load(File.read(yml_file))
  end

  def self.find_with_layers(twemoji_version, id)
    all(twemoji_version)[id]
  end

  def self.find_with_features(twemoji_version, id)
    layers = find_with_layers(twemoji_version, id)

    return if layers.nil?

    layers.each_with_object({}) do |(key, value), out|
      value = value['name'] if value.is_a?(Hash)
      out[value.to_sym] ||= []
      out[value.to_sym] << key
    end
  end
end
