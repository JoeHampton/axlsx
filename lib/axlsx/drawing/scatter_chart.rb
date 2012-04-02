# encoding: UTF-8
module Axlsx

  # The ScatterChart allows you to insert a scatter chart into your worksheet
  # @see Worksheet#add_chart
  # @see Chart#add_series
  # @see README for an example
  class ScatterChart < Chart

    # The Style for the scatter chart
    # must be one of :none | :line | :lineMarker | :marker | :smooth | :smoothMarker
    # return [Symbol]
    attr_reader :scatterStyle

    # the x value axis
    # @return [ValAxis]
    attr_reader :xValAxis

    # the y value axis
    # @return [ValAxis]
    attr_reader :yValAxis

    # Creates a new scatter chart
    def initialize(frame, options={})
      @scatterStyle = :lineMarker
      @xValAxId = rand(8 ** 8)
      @yValAxId = rand(8 ** 8)
      @xValAxis = ValAxis.new(@xValAxId, @yValAxId)
      @yValAxis = ValAxis.new(@yValAxId, @xValAxId)
      super(frame, options)
      @series_type = ScatterSeries
      options.each do |o|
        self.send("#{o[0]}=", o[1]) if self.respond_to? "#{o[0]}="
      end
    end

    # see #scatterStyle
    def scatterStyle=(v)
      Axlsx.validate_scatter_style(v)
      @scatterStyle = v
    end

    # Serializes the object
    # @param [String] str
    # @return [String]
    def to_xml_string(str = '')
      super do |str|
        str << '<c:scatterChart>'
        str << '<c:scatterStyle val="' << scatterStyle.to_s << '"/>'
        str << '<c:varyColors val="1"/>'
        @series.each { |ser| ser.to_xml_string(str) }
        str << '<c:dLbls>'
        str << '<c:showLegendKey val="0"/>'
        str << '<c:showVal val="0"/>'
        str << '<c:showCatName val="0"/>'
        str << '<c:showSerName val="0"/>'
        str << '<c:showPercent val="0"/>'
        str << '<c:showBubbleSize val="0"/>'
        str << '</c:dLbls>'
        str << '<c:axId val="' << @xValAxId.to_s << '"/>'
        str << '<c:axId val="' << @yValAxId.to_s << '"/>'
        str << '</c:scatterChart>'
        @xValAxis.to_xml_string str
        @yValAxis.to_xml_string str
      end
      str
    end
  end
end
