# encoding: UTF-8
module Axlsx
  # This class details a single cell anchor for drawings.
  # @note The recommended way to manage drawings, images and charts is Worksheet#add_chart or Worksheet#add_image.
  # @see Worksheet#add_chart
  # @see Worksheet#add_image
  class OneCellAnchor

    # A marker that defines the from cell anchor. The default from column and row are 0 and 0 respectively
    # @return [Marker]
    attr_reader :from

    # The object this anchor hosts
    # @return [Pic]
    attr_reader :object

    # The drawing that holds this anchor
    # @return [Drawing]
    attr_reader :drawing

    # the width of the graphic object in pixels.
    # this is converted to EMU at a 92 ppi resolution
    # @return [Integer]
    attr_reader :width

    # the height of the graphic object in pixels
    # this is converted to EMU at a 92 ppi resolution
    # @return [Integer]
    attr_reader :height


    # Creates a new OneCellAnchor object and an Pic associated with it.
    # @param [Drawing] drawing
    # @option options [Array] start_at the col, row to start at
    # @option options [Integer] width
    # @option options [Integer] height
    # @option options [String] image_src the file location of the image you will render
    # @option options [String] name the name attribute for the rendered image
    # @option options [String] descr the description of the image rendered
    def initialize(drawing, options={})
      @drawing = drawing
      @width = 0
      @height = 0
      drawing.anchors << self
      @from = Marker.new
      options.each do |o|
        self.send("#{o[0]}=", o[1]) if self.respond_to? "#{o[0]}="
      end
      @object = Pic.new(self, options)
    end

    # @see height
    def height=(v) Axlsx::validate_unsigned_int(v); @height = v; end

    # @see width
    def width=(v) Axlsx::validate_unsigned_int(v); @width = v; end

    # The index of this anchor in the drawing
    # @return [Integer]
    def index
      @drawing.anchors.index(self)
    end


    # Serializes the object
    # @param [String] str
    # @return [String]
    def to_xml_string(str = '')
      str << '<xdr:oneCellAnchor>'
      str << '<xdr:from>'
      from.to_xml_string(str)
      str << '</xdr:from>'
      str << '<xdr:ext cx="' << ext[:cx].to_s << '" cy="' << ext[:cy].to_s << '"/>'
      @object.to_xml_string(str)
      str << '<xdr:clientData/>'
      str << '</xdr:oneCellAnchor>'
    end

    private

    # converts the pixel width and height to EMU units and returns a hash of
    # !{:cx=>[Integer], :cy=>[Integer]
    # @return [Hash]
    def ext
      cy = @height * 914400 / 96
      cx = @width * 914400 / 96
      {:cy=>cy, :cx=>cx}
    end

  end
end
