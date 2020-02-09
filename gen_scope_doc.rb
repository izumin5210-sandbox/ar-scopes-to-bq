# based on activerecord-spanner-adapter
# https://github.com/supership-jp/activerecord-spanner-adapter/blob/2735852b03f7d2f253b698749530b881f29728f7/lib/active_record/connection_adapters/spanner/quoting.rb
module Quoting
  IDENTIFIERS_PATTERN = /\A[a-zA-Z][a-zA-Z0-9_]*\z/

  def quote_identifier(name)
    # https://cloud.google.com/spanner/docs/data-definition-language?hl=ja#ddl_syntax
    # raise ArgumentError, "invalid table name #{name}" unless IDENTIFIERS_PATTERN =~ name
    "`#{name}`"
  end

  def quote_table_name(name)
    quote_identifier("rdb.#{name}")
  end

  # alias quote_table_name quote_identifier
  alias quote_column_name quote_identifier
  
  def quote_table_name_for_assignment(table, attr)
    p table, attr
    super
  end


  private
  def _type_cast(value)
    # NOTE: Spanner APIs are strongly typed unlike typical SQL interfaces.
    # So we don't want to serialize the value into string unlike other adapters.
    case value
    when Symbol, ActiveSupport::Multibyte::Chars, ActiveRecord::Type::Binary::Data
      value.to_s
    else
      value
    end
  end

  def _quote(value)
    case value
    when Symbol, String, ActiveSupport::Multibyte::Chars, ActiveRecord::Type::Binary::Data
      quote_string(value.to_s)
    when true
      quoted_true
    when false
      quoted_false
    when nil
      'NULL'
    when Numeric, ActiveSupport::Duration
      value.to_s
    when ActiveRecord::Type::Time::Value
      %Q["#{quoted_time(value)}"]
    when Date, Time
      %Q["#{quoted_date(value)}"]
    else
      raise TypeError, "can't quote #{value.class.name}"
    end
  end

  def quote_string(value)
    # Not sure but string-escape syntax in SELECT statements in Spanner
    # looks to be the one in JSON by observation.
    JSON.generate(value)
  end

  def quoted_true
    'true'
  end

  def quoted_false
    'false'
  end
end

# module QuotingRefinement
#   refine ActiveRecord::ConnectionAdapters::PostgreSQLAdapter do
#     include Quoting
#   end
# end

YARD.parse Rails.root.join('app', '**', '*.rb').to_s

ar_classes =
  YARD::Registry.select do |y|
    y.type == :class && y.inheritance_tree.include?(P(ActiveRecord::Base))
  end

ar_classes.each do |class_doc|
  ar_class = Object.const_get class_doc.name
  scope_docs = class_doc.meths.select { |m| m.scope == :class && m.group == 'Scopes' }

  next unless scope_docs.present?

  ar_class.column_names

  puts "## `#{class_doc.name}`"

  scope_docs.each do |scope_doc|
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include Quoting

    puts "### `#{scope_doc.name}`"
    puts scope_doc.docstring if scope_doc.docstring.present?
    puts
    # using QuotingRefinement
    puts '```sql'
    puts ar_class.send(scope_doc.name).to_sql
    puts '```'
    puts
  end
end
