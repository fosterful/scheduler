# frozen_string_literal: true

module Services
  module BulkInserter
    class Error < StandardError; end
    class Insert
      include Procto.call(:insert)
      include Concord.new(:records)
      include Adamantium::Flat

      def insert
        raise(BulkInserter::Error, 'Some records were invalid!') if records.any? { |r| !r.valid? }

        ActiveRecord::Base.connection.execute(insert_sql)
      end

      private

      def present_attributes_for(record)
        record.attributes.select { |_, v| v.present? }.tap do |attrs|
          now = Time.zone.now
          %w(created_at updated_at).each { |v| attrs[v] ||= now }
        end
      end

      def column_names
        names = records.map { |r| present_attributes_for(r).keys }
        names.inject do |a, b|
          a != b ? raise(BulkInserter::Error, 'All records must have the same attributes present') : b
        end
      end

      def table_name
        names = records.map { |r| r.class.table_name }
        names.inject do |a, b|
          a != b ? raise(BulkInserter::Error, 'All records must have the same table name') : b
        end
      end

      def rows_to_insert
        records.map { |r| present_attributes_for(r) }
      end

      def values_sql
        rows_to_insert.map { |row| "(#{prepare_row(row)})" }.join(',')
      end

      def prepare_row(row)
        row.map { |_, v| prepare_value(v) }.join(',')
      end

      def prepare_value(v)
        quote(v.respond_to?(:utc) ? v.utc : v)
      end

      def quote(s)
        "'#{s}'"
      end

      def insert_sql
        "INSERT INTO #{table_name} (#{column_names.join(', ')}) VALUES #{values_sql}"
      end
    end
  end
end
