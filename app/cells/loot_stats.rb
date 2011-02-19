class LootStats < Apotomo::Widget
  def display
    @ls = options[:ls]
    render
  end
end
