module Helpers::Parsable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def parse_all
      klass = self
      if klass.name.blank?
        klass = self.superclass
      end
      puts "Parsing '#{klass.name&.pluralize}' (#{klass}) and saving..."
      klass.in_batches(of: 250, order: :desc) do |entities|
        entities.each do |entity|
          # puts "parsing #{entity}"
          entity.parse
        end
      end
      puts "done!"
    end

    def run_on_all(symbol, scope = nil)
      unless scope
        klass = self
        if klass.name.blank?
          klass = self.superclass
        end
      else
        klass = scope
      end
      puts "Running #{symbol} on '#{klass.name&.pluralize}' (#{klass})..."
      klass.in_batches(of: 250, order: :desc) do |entities|
        entities.each do |entity|
          # puts "parsing #{entity}"
          entity.send(symbol)
        end
      end
      puts "done!"
    end

    def run_on_all_and_save(symbol)
      klass = self
      if klass.name.blank?
        klass = self.superclass
      end
      puts "Running #{symbol} on '#{klass.name&.pluralize}' (#{klass})..."
      klass.in_batches(of: 250, order: :desc) do |entities|
        entities.each do |entity|
          # puts "parsing #{entity}"
          entity.send(symbol)
          entity.save
        end
      end
      puts "done!"
    end

    def parse_all_and_save
      klass = self
      if klass.name.blank?
        klass = self.superclass
      end
      puts "Parsing '#{klass.name&.pluralize}' (#{klass}) and saving..."
      begin
        puts "Count: #{klass.count}..."
        count = 0
        klass.in_batches(of: 250, order: :desc) do |entities|
          entities.each do |entity|
            begin
              entity.parse_and_save
            rescue Exception => ex
              Rails.logger.error "could not parse: #{entity.class.name} ##{entity.id} -> #{ex} #{ex.backtrace.join('\n')}"
              # puts "could not parse: #{entity.class.name} ##{entity.id} -> #{ex}".red
            end
            count += 1
            Rails.logger.info "#{count}/#{klass.count} (#{(count.to_f / klass.count * 100).to_i}%)" if count % 100 == 0
          end
        end
      rescue Exception => ex
        Rails.logger.error "#{ex}"
        # binding.pry
      end
      puts "done!"
    end
  end

  def self.includers
    ObjectSpace.each_object(Class).select { |c| c.included_modules.include?(::Helpers::Parsable) }.map{ |c| c.name.blank? ? c.superclass : c }.uniq
  end

  def self.parse_all(classes=nil)
    if classes.nil?
      classes = self.includers
    end
    classes.each do |klass|
      klass.parse_all
    end
    true
  end

  def self.parse_all_and_save(classes=nil, automation=nil)
    if classes.nil?
        classes = self.includers
    end
    i = 0
    classes_size = classes.size
    classes.each do |klass|
      puts "#{klass.name}"
      new_percent = (i+=1.to_f / classes_size * 100).to_i
      automation&.last_percentage = new_percent if automation
      klass.parse_all_and_save
    end
    true
  end

  def parse

  end

  def parse_created_at(field='created_at')
    date_str = properties[field]&.to_datetime
    if date_str
      update_column(:created_at, date_str) if persisted?
      self.created_at = date_str.to_datetime unless persisted?
    end
  end

  def parse_updated_at(field='updated_at')
    date_str = properties[field]&.to_datetime
    if date_str
      update_column(:updated_at, date_str) if persisted?
      self.updated_at = date_str.to_datetime unless persisted?
    end
  end

  def parse_and_save
    parse
    return save if changed? or !persisted?
    false
  end
end
