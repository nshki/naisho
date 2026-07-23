require "net/http"
require "csv"

# Fetches and parses CSV files sourced from remote data providers.
class RemoteCsv
  # Fetches the CSV at the given URI and parses it with headers.
  #
  # Strips a leading UTF-8 byte order mark if present. Some providers serve their CSVs
  # with a BOM, which otherwise gets prepended to the first column's header (e.g.
  # "\uFEFFName") and silently breaks header-based row lookups for it.
  #
  # When a block is given each row is yielded as a `CSV::Row`; otherwise the parsed
  # `CSV::Table` is returned.
  #
  # @param uri [URI]
  # @param parse_options [Hash] Additional options forwarded to `CSV.parse`.
  # @yield [CSV::Row]
  # @return [CSV::Table, nil]
  def self.each_row(uri, **parse_options, &block)
    body = Net::HTTP.get(uri).force_encoding("UTF-8").delete_prefix("\uFEFF")
    CSV.parse(body, headers: true, **parse_options, &block)
  end
end
