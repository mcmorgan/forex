Forex::Trader.define "FXTRADERS" do |t|
  t.base_currency = "JMD"
  t.name          = "FX Traders"
  t.endpoint      = "http://www.fxtrader.gkmsonline.com/rates"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    content_for = ->(type, n, part = nil) do
      doc.css(
        ['.views-field-field-fx-trader', type, n, part].compact.join('-').concat(' .field-content')
      ).first.content
    end

    translations = {
      'EURO' => 'EUR',
    }

    (1..5).each_with_object({}) do |n, currencies|
      currency_code = content_for.(:currency, n)
      currency_code = translations[currency_code] || currency_code

      currencies[currency_code] = {
        buy_cash:   content_for.(:buying, n).to_f,
        buy_draft:  content_for.(:buying, n, :b).to_f,
        sell_cash:  content_for.(:selling, n).to_f,
        sell_draft: content_for.(:selling, n, :b).to_f,
      }
    end
  end
end
