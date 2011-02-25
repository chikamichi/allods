module LootStatusWidgets
  class ContainerWidget < AllodsWidget
    #has_widgets do |me|
      #@ls = options[:ls]

      # Each metadata of this LootStatus widget is attached a widget, which will
      # respond to value change with the appropriate behavior. A reference to the parent
      # is passed as :ls so that one can retrieve the proper objects through the Rails
      # relationships.
      #
      #@ls.metadatas.each do |key, value|
        #me << widget('strategy_metadata', "strategy_metadata_#{@ls.id}_#{key}", :ls => @ls)
      #end
    #end
  end
end
