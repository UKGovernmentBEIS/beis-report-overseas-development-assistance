# frozen_string_literal: true

module CodelistHelper
  def yaml_to_objects(entity, type, with_empty_item = true)
    data = load_yaml(entity, type)
    return [] if data.empty?

    objects = data.collect { |item| OpenStruct.new(name: item["name"], code: item["code"]) }.sort_by(&:name)
    if with_empty_item
      empty_item = OpenStruct.new(name: "", code: "")
      objects.unshift(empty_item)
    end
    objects
  end

  def currency_select_options
    objects = yaml_to_objects("generic", "default_currency", false)
    objects.unshift(OpenStruct.new(name: "Pound Sterling", code: "GBP")).uniq
  end

  def load_yaml(entity, type)
    yaml = YAML.safe_load(File.read("#{Rails.root}/vendor/data/codelists/IATI/#{IATI_VERSION}/#{entity}/#{type}.yml"))
    yaml["data"]
  rescue
    []
  end
end
